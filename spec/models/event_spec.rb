require 'rails_helper'

RSpec.describe Event, type: :model do

  it { is_expected.to validate_presence_of :address }
  it { is_expected.to validate_length_of :title }
  it { is_expected.to belong_to :ngo }

  it { is_expected.to have_many(:shifts).dependent(:destroy).order(starts_at: :asc) }

  it { is_expected.to accept_nested_attributes_for :shifts }

  describe 'state' do
    let(:event) { create :event }

    it 'has initial state :pending' do
      expect(event).to be_pending
    end

    it 'can transition from pending to :publish' do
      expect(event).to transition_from(:pending).to(:published).on_event(:publish)
    end

    it 'cannot transition from :published to anywhere' do
      event = create :event, :published
      expect(event).to_not allow_transition_to :pending
    end
  end

  # describe '#starts_at, #ends_at' do
  #   let(:event) { create :event }
  #   let(:start_time) { Time.now+1.day }
  #   let(:end_time) { start_time+2.hours }
  #   let(:full_shift) { create :shift, event: event,
  #     starts_at: start_time+1.day, ends_at: end_time+1.day,
  #     volunteers_needed: 1, volunteers_count: 1 }
  #   let(:past_shift) { create :shift, event: event,
  #     starts_at: start_time-1.day, ends_at: end_time-1.day,
  #     volunteers_needed: 1, volunteers_count: 1 }
  #
  #   context 'when multiple shifts available' do
  #     let!(:first_available_shift) { create :shift, event: event,
  #       starts_at: start_time, ends_at: end_time,
  #       volunteers_needed: 1, volunteers_count: 0 }
  #     let!(:last_available_shift) { create :shift, event: event,
  #       starts_at: start_time+1.hour, ends_at: end_time+1.hour,
  #       volunteers_needed: 1, volunteers_count: 0 }
  #
  #     it 'returns starts_at for first available shift' do
  #       expect(event.starts_at).to eq start_time
  #     end
  #
  #     it 'returns ends_at for last available shift' do
  #       expect(event.ends_at).to eq end_time+1.hour
  #     end
  #   end
  #   context 'when shift available' do
  #     let!(:available_shift) { create :shift, event: event,
  #       starts_at: start_time, ends_at: end_time,
  #       volunteers_needed: 1, volunteers_count: 0 }
  #
  #     it 'returns starts_at for available shift' do
  #       expect(event.starts_at).to eq start_time
  #     end
  #
  #     it 'returns ends_at for available shift' do
  #       expect(event.ends_at).to eq end_time
  #     end
  #   end
  #   context 'when no shifts available' do
  #     it 'returns nil for start' do
  #       expect(event.starts_at).to eq nil
  #     end
  #
  #     it 'returns nil for end' do
  #       expect(event.ends_at).to eq nil
  #     end
  #   end
  # end

  describe '#user_opted_in?' do
    let(:event) { create :event }
    let(:available_shift) { create :shift, event: event }
    let(:past_shift) { create :shift, :past, event: event }
    let(:user) { create :user }

    subject(:user_in?) { event.user_opted_in? user }

    it 'returns true if user opted into available shift' do
      available_shift.users << user
      expect(user_in?).to eq true
    end

    it 'returns false if user opted into past shift' do
      past_shift.users << user
      expect(user_in?).to eq false
    end

    it 'returns false if user opted into no shift' do
      expect(user_in?).to eq false
    end
  end

  # describe '#volunteers_needed, #volunteers_count' do
  #   let(:event) { create :event }
  #   let!(:available_shifts) { create_list :shift, 3, event: event,
  #     volunteers_needed: 2, volunteers_count: 1 }
  #   let!(:past_shift) { create :shift, :past, event: event }
  #
  #   it 'returns sum of volunteers_needed for available_shifts' do
  #     expect(event.volunteers_needed).to eq 6
  #   end
  #
  #   it 'returns sum of volunteers_count for available_shifts' do
  #     expect(event.volunteers_count).to eq 3
  #   end
  # end
end
