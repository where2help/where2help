require 'rails_helper'

RSpec.describe Shift, type: :model do
  it { is_expected.to have_many(:users)}
  it { is_expected.to belong_to(:event)}

  it { is_expected.to validate_presence_of(:volunteers_needed)}
  it { is_expected.to validate_presence_of(:starts_at)}
  it { is_expected.to validate_presence_of(:ends_at)}

  describe 'callbacks' do
    describe 'before_destroy' do
      let(:shift) { create :shift, :with_event }
      before { create_list :shifts_user, 4, shift: shift}

      it 'sends an email to each user' do
        expect{
          shift.destroy
        }.to change { ActionMailer::Base.deliveries.count }.by 4
      end
    end
  end
  describe 'scopes' do
    describe '.past' do
      let!(:upcoming) { create :shift, :with_event, starts_at: Time.now+1.day }
      let!(:oldest) { create :shift, :with_event, :skip_validate, starts_at: Time.now-1.day }
      let!(:old) { create :shift, :with_event, :skip_validate, starts_at: Time.now-12.hours }
      let!(:middle) { create :shift, :with_event, :skip_validate, starts_at: Time.now-2.hours }
      let!(:newest) { create :shift, :with_event, :skip_validate, starts_at: Time.now-1.hour }

      subject(:shifts) { Shift.past }

      it 'excludes upcoming shifts' do
        expect(shifts).not_to include upcoming
      end

      it 'sorts shifts by starts_at time descending' do
        expect(shifts.to_a).to eq [newest, middle, old, oldest]
      end
    end
    describe '.upcoming' do
      let!(:past) { create :shift, :with_event, :skip_validate, starts_at: Time.now-1.hour }
      let!(:earliest) { create :shift, :with_event, starts_at: Time.now+1.hour }
      # let!(:middle) { create :shift, :skip_validate, starts_at: Time.now+2.hours }
      # let!(:early) { create :shift, :skip_validate, starts_at: Time.now+1.day }


      subject(:shifts) { Shift.upcoming }

      it 'excludes past shifts' do
        expect(shifts).not_to include past
      end

      it 'sorts shifts by starts_at time ascending' do
        expect(shifts.to_a).to include earliest
      end
    end
  end
end
