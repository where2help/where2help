require 'rails_helper'

RSpec.describe Shift, type: :model do
  it { is_expected.to have_many(:users)}
  it { is_expected.to belong_to(:event)}

  it { is_expected.to validate_presence_of(:volunteers_needed)}
  it { is_expected.to validate_presence_of(:starts_at)}
  it { is_expected.to validate_presence_of(:ends_at)}

  describe 'callbacks' do
    describe 'before_destroy' do
      let(:shift) { create :shift }
      before { create_list :shifts_user, 4, shift: shift}

      it 'sends an email to each user' do
        expect{
          shift.destroy
        }.to change { ActionMailer::Base.deliveries.count }.by 4
      end
    end
  end
end
