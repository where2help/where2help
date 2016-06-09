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
  describe '#starts_at and #ends_at' do
    let!(:event) { create :event }
    let!(:first_shift) { create :shift, event: event, starts_at: Time.now+1.hour }
    let!(:last_shift) { create :shift, event: event, ends_at: Time.now+3.days }

    before do
      create :shift, :full, event: event, starts_at: Time.now+1.hour
      past_shift = build :shift, :past, event: event, starts_at: Time.now+1.hour
      past_shift.save(validate: false)
    end

    it 'returns starts_at of first available_shift' do
      expect(event.starts_at.to_s).to eq first_shift.starts_at.to_s
    end

    it 'returns ends_at of first available_shift' do
      expect(event.ends_at.to_s).to eq last_shift.ends_at.to_s
    end
  end
  describe '#available_shifts' do
    let(:event) { create :event }
    let(:available_shift) { create :shift, event: event }
    let(:past_shift) do
      past_shift = build :shift, :past, event: event
      past_shift.save(validate: false)
      return past_shift
    end
    let(:full_shift) { create :shift, :full, event: event }

    subject(:available_shifts) { event.available_shifts }

    it 'includes upcoming shifts with free slots' do
      expect(available_shifts).to include available_shift
    end

    it 'excludes past shifts' do
      expect(available_shifts).not_to include past_shift
    end

    it 'excludes full shifts' do
      expect(available_shifts).not_to include full_shift
    end
  end
  describe '#user_opted_in?' do
    let(:event) { create :event }
    let(:available_shift) { create :shift, event: event }
    let(:past_shift) do
      past_shift = build :shift, :past, event: event
      past_shift.save(validate: false)
      return past_shift
    end
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
  describe '#volunteers_needed and #volunteers_count' do
    let(:event) { create :event }

    before do
      create_list :shift, 2, event: event, volunteers_needed: 2, volunteers_count: 1
      my_past_shift = build :shift, :past, event: event, volunteers_needed: 100
      my_past_shift.save(validates: false)
      create :shift, event: event, volunteers_needed: 100, volunteers_count: 100
    end

    it 'sums up all available_shifts volunteers_needed' do
      expect(event.volunteers_needed).to eq 14
    end

    it 'sums up all available_shifts volunteers_count' do
      expect(event.volunteers_count).to eq 2
    end
  end
end
