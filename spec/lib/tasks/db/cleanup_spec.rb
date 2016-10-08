require 'rails_helper'
require 'rake'

RSpec.describe 'db:cleanup' do
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
    it "deletes records older than one year" do
      create_list :user, 2, deleted_at: nil
      create_list :user, 2, deleted_at: Time.now
      create :user, deleted_at: 2.years.ago

      expect { task.invoke }.to change { User.unscoped.count }.from(5).to(4)
    end
  end
end
