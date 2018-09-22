require 'rails_helper'

RSpec.describe Shift, type: :model do
  it { is_expected.to have_many(:participations).dependent(:destroy) }
  it { is_expected.to have_many(:users) }
  it { is_expected.to belong_to(:event) }
  it { is_expected.to act_as_paranoid }

  describe 'validations' do
    it { expect(create(:shift, :with_event)).to be_valid }

    it { is_expected.to validate_presence_of(:volunteers_needed) }
    it { is_expected.to validate_presence_of(:starts_at) }
    it { is_expected.to validate_presence_of(:ends_at) }
  end

  describe 'callbacks' do
    describe 'before_destroy' do
      let(:shift) { create :shift, :with_event, :with_ngo }
      before { create_list :participation, 4, shift: shift }

      it 'sends an email to each user' do
        expect  do
          shift.destroy
        end.to change { ActionMailer::Base.deliveries.count }.by 4
      end
    end
    describe 'users' do
      let(:shift) { create :shift, :with_event, :with_ngo }
      let(:user) { create :user }

      before { shift.users << user }

      it 'destroys join record on destroy' do
        expect  do
          shift.destroy
        end.to change { Participation.count }.by -1
      end
      it 'does not destroy user record on destroy' do
        expect  do
          shift.destroy
        end.not_to change { User.count }
      end
    end

    describe 'before_update' do
      let(:shift) { create :shift, :with_event, :with_ngo }
      before { create_list :participation, 4, shift: shift }

      it 'sends an email to each user' do
        expect  do
          shift.save
        end.to change { ActionMailer::Base.deliveries.count }.by 4
      end
    end
  end

  describe 'scopes' do
    describe '.past' do
      let!(:upcoming) { create :shift, :with_event, starts_at: 1.day.from_now, ends_at: 1.day.from_now + 2.hours }
      let!(:oldest) { create :shift, :with_event, :skip_validate, starts_at: 1.day.ago, ends_at: 1.day.ago + 2.hours }
      let!(:old) { create :shift, :with_event, :skip_validate, starts_at: 12.hours.ago, ends_at: 10.hours.ago }
      let!(:middle) { create :shift, :with_event, :skip_validate, starts_at: 2.hours.ago, ends_at: 1.hour.ago }
      let!(:newest) { create :shift, :with_event, :skip_validate, starts_at: 1.hour.ago, ends_at: 15.minutes.ago }

      subject(:shifts) { Shift.past }

      it 'excludes upcoming shifts' do
        expect(shifts).not_to include upcoming
      end

      it 'sorts shifts by starts_at time descending' do
        expect(shifts.to_a).to eq [newest, middle, old, oldest]
      end
    end
    describe '.upcoming' do
      let!(:past) { create :shift, :with_event, :skip_validate, starts_at: 1.hour.ago, ends_at: 30.minutes.ago }
      let!(:earliest) { create :shift, :with_event, starts_at: Time.now + 1.hour }
      let!(:middle) { create :shift, :with_event, :skip_validate, starts_at: Time.now + 2.hours }
      let!(:early) { create :shift, :with_event, :skip_validate, starts_at: Time.now + 1.day }

      subject(:shifts) { Shift.upcoming }

      it 'excludes past shifts' do
        expect(shifts).not_to include past
      end

      it 'sorts shifts by starts_at time ascending' do
        expect(shifts.to_a).to eq [earliest, middle, early]
      end
    end
    describe '.not_full' do
      let(:event) { create :event, :with_shift }
      let(:available_shift) { create :shift, event: event }
      let(:full_shift) { create :shift, :full, event: event }

      subject(:shifts) { Shift.not_full }

      it 'includes available shifts' do
        expect(shifts).to include available_shift
      end

      it 'excludes full shifts' do
        expect(shifts).not_to include full_shift
      end
    end
    describe '#available' do
      let(:event) { create :event, :with_shift }
      let(:not_full) { create :shift, event: event }
      let(:full) { create :shift, :full, event: event }
      let(:past) { create :shift, :past, :skip_validate, event: event }

      subject(:shifts) { Shift.available }

      it 'includes upcoming not full shifts' do
        expect(shifts).to include not_full
      end

      it 'excludes full shifts' do
        expect(shifts).not_to include full
      end

      it 'excludes past shifts' do
        expect(shifts).not_to include past
      end
    end
  end

  describe '.filtered_for_ngo' do
    let(:ngo)          { create :ngo }
    let(:past_event)   { create :event, :skip_validate, :published, ngo: ngo, title: "D", address: "Doo St." }
    let(:first_event)  { create :event, :skip_validate, :published, ngo: ngo, title: "B", address: "Coo St." }
    let(:second_event) { create :event, :skip_validate, :published, ngo: ngo, title: "A", address: "Boo St." }
    let(:third_event)  { create :event, :skip_validate, :published, ngo: ngo, title: "C", address: "Aoo St." }

    before do
      create :shift, :skip_validate, event: past_event, starts_at: Time.now - 1.hour, ends_at: Time.now - 30.minutes
      create :shift, event: first_event, starts_at: Time.now + 1.hour
      create :shift, event: second_event, starts_at: Time.now + 2.hours
      create :shift, event: second_event, starts_at: Time.now + 3.hours
      create :shift, event: second_event, starts_at: Time.now + 1.day
      create :shift, event: third_event, starts_at: Time.now + 3.hours
    end

    it "gets shifts on different dates" do
      shifts = Shift.filtered_for_ngo(ngo, nil)
      expect(shifts.to_a.size).to eq(5)
    end
    it "can filter for shifts in the past" do
      shifts = Shift.filtered_for_ngo(ngo, :past)
      expect(shifts.map(&:event)).to eq([past_event])
    end
  end

  describe '#progress_bar' do
    let(:shift) { create :shift, :with_event }
    let(:user) { create :user }

    subject { shift.progress_bar user }

    context 'when user no participant' do
      it 'returns a new ProgressBar without offset' do
        expect(ProgressBar).to receive(:new)
          .with(progress: anything, total: anything, offset: 0)
          .and_call_original
        expect(subject).to be_a ProgressBar
      end
    end
    context 'when user participant' do
      before { create(:participation, shift: shift, user: user) }

      it 'returns a new ProgressBar with offset 1' do
        expect(ProgressBar).to receive(:new)
          .with(progress: anything, total: anything, offset: 1)
          .and_call_original
        expect(subject).to be_a ProgressBar
      end
    end
    context 'when user nil' do
      let(:user) { nil }

      it 'returns a new ProgressBar without offset' do
        expect(ProgressBar).to receive(:new)
          .with(progress: anything, total: anything, offset: 0)
          .and_call_original
        expect(subject).to be_a ProgressBar
      end
    end
  end
end
