# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'db:anonymize_deleted_users' do
  let(:task_name) { self.class.top_level_description }

  before do
    Rake.application.rake_require "tasks/#{task_name.tr(':', '/')}"
    Rake::Task.define_task(:environment)
    task.reenable
  end

  subject(:task) { Rake::Task[task_name] }

  it 'does not raise exception' do
    expect { task.invoke }.not_to raise_exception
  end

  context 'when deleted user records' do
    it "anonymizes records older than one year" do
      create_list :user, 2, deleted_at: nil
      create_list :user, 2, deleted_at: Time.now
      user = create :user, deleted_at: 2.years.ago
      old_encrypted_password = user.encrypted_password

      expect { task.invoke }.to change { User.unscoped.where("anonymized_at IS NOT NULL").count }.from(0).to(1)

      expect { user.reload }.not_to raise_exception
      expect(user.first_name).to eq("(anonymized)")
      expect(user.last_name).to eq("(anonymized)")
      expect(user.email).to eq("user-#{user.id}@anonymized.where2help.wien")
      expect(user.phone).to eq("")
      expect(user.first_name).not_to eq(old_encrypted_password)
      expect(user.anonymized_at).not_to be_nil
    end
  end
end
