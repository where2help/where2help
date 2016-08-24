require 'rails_helper'

RSpec.describe Event, type: :model do

  it { is_expected.to validate_presence_of :address }
  it { is_expected.to validate_length_of :title }
  it { is_expected.to belong_to :ngo }

  it { is_expected.to have_many(:shifts).dependent(:destroy).order(starts_at: :asc) }

  it { is_expected.to accept_nested_attributes_for :shifts }

  describe 'state' do
    let(:event) { create :event, :with_shift }

    it 'has initial state :pending' do
      expect(event).to be_pending
    end

    it 'can transition from pending to :publish' do
      expect(event).to transition_from(:pending).to(:published).on_event(:publish)
    end

    it 'cannot transition from :published to anywhere' do
      event = create :event, :published, :with_shift
      expect(event).to_not allow_transition_to :pending
    end
  end

  describe 'callbacks' do
    let(:event) { create :event, :skip_validate }

    it 'destroys shift record on destroy' do
      create :shift, event: event
      expect{
        event.destroy
      }.to change{Shift.count}.by -1
    end
  end

  describe 'associations' do
    describe '#available_shifts' do
      let(:event) { create :event, :with_shift }
      let(:available_shift) { create :shift, event: event }
      let(:past_shift) { create :shift, :skip_validate, :past, event: event }
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
  end

  describe 'scopes' do
    describe '.with_available_shifts' do
      let(:pending_event) { create :event, :with_shift }
      let(:full_event) { create :event, :skip_validate, :published }
      let(:past_event) { create :event, :skip_validate, :published }
      let(:third_event) { create :event, :skip_validate, :published }
      let(:second_event) { create :event, :skip_validate, :published }
      let(:first_event) { create :event, :skip_validate, :published }

      subject(:events) { Event.with_available_shifts }

      before do
        create :shift, :skip_validate, event: past_event, starts_at: Time.now-1.hour
        create :shift, event: first_event, starts_at: Time.now+1.hour
        create :shift, event: second_event, starts_at: Time.now+2.hours
        create :shift, :full, event: full_event
        create :shift, event: third_event, starts_at: Time.now+3.hours
      end

      it 'excludes pending events' do
        expect(events).not_to include pending_event
      end

      it 'excludes events with only full shifts' do
        expect(events).not_to include full_event
      end

      it 'excludes events with only past shifts' do
        expect(events).not_to include past_event
      end

      it 'returns events with available shifts ordered by their starts time' do
        expect(events.to_a).to eq [first_event, second_event, third_event]
      end
    end
    describe '.upcoming, .past' do
      let(:upcoming_event) { create :event, :skip_validate }
      let(:past_event) { create :event, :skip_validate }

      before do
        create :shift, event: upcoming_event, starts_at: Time.now+1.hour
        create :shift, :skip_validate, event: past_event, starts_at: Time.now-1.hour
      end

      describe 'upcoming' do
        subject(:events) { Event.upcoming }

        it 'includes events with upcoming shifts' do
          expect(events).to include upcoming_event
        end
        it 'excludes events with past shifts' do
          expect(events).not_to include past_event
        end
      end
      describe 'past' do
        subject(:events) { Event.past }

        it 'includes events with past shifts' do
          expect(events).to include past_event
        end
        it 'excludes events with upcoming shifts' do
          expect(events).not_to include upcoming_event
        end
      end
    end
  end

  describe '.filter' do
    it 'calls :all scope when passing no params' do
      expect(Event).to receive(:all)
      Event.filter
    end
    it 'calls :all scope when passing nil' do
      expect(Event).to receive(:all)
      Event.filter(nil)
    end
    it 'calls :past when passing :past' do
      expect(Event).to receive(:past)
      Event.filter(:past)
    end
    it 'calls :upcoming when passing :upcoming' do
      expect(Event).to receive(:upcoming)
      Event.filter(:upcoming)
    end
    it 'raises ArgumentError when passing a non-existing scope' do
      expect{
        Event.filter(:some_random_crap123)
      }.to raise_error ArgumentError
    end
  end

  describe '#starts_at and #ends_at' do
    let!(:event) { create :event, :with_shift }
    let!(:first_shift) { create :shift, event: event, starts_at: Time.now+1.hour }
    let!(:last_shift) { create :shift, event: event, ends_at: Time.now+3.days }

    before do
      create :shift, :full, event: event, starts_at: Time.now+1.hour
      create :shift, :skip_validate, :past, event: event, starts_at: Time.now+1.hour
    end

    it 'returns starts_at of first available_shift' do
      expect(event.starts_at.to_s).to eq first_shift.starts_at.to_s
    end

    it 'returns ends_at of first available_shift' do
      expect(event.ends_at.to_s).to eq last_shift.ends_at.to_s
    end
  end

  describe '#volunteers_needed and #volunteers_count' do
    context 'when upcoming shifts' do
      let(:event) { create :event, :skip_validate }
      before do
        create_list :shift, 2, event: event, volunteers_needed: 2, volunteers_count: 1
        create :shift, :skip_validate, :past, event: event, volunteers_needed: 100
        create :shift, event: event, volunteers_needed: 10, volunteers_count: 0
      end

      it 'sums up all available_shifts volunteers_needed' do
        expect(event.volunteers_needed).to eq 14
      end

      it 'sums up all available_shifts volunteers_count' do
        expect(event.volunteers_count).to eq 2
      end
    end
    context 'when no upcoming shifts at all' do
      let(:event) { create :event, :skip_validate }
      before do
        create_list :shift, 2, :skip_validate, :past,
          event: event, volunteers_needed: 10, volunteers_count: 1
      end

      it 'sums up all shifts volunteers_needed' do
        expect(event.volunteers_needed).to eq 20
      end

      it 'sums up all shifts volunteers_count' do
        expect(event.volunteers_count).to eq 2
      end
    end
  end

  describe '#progress_bar' do
    context 'when called without params' do
      let(:event) { create :event, :with_shift }

      subject { event.progress_bar }

      it 'returns a public progress bar' do
        expect(subject).to be_a ProgressBar::Public
      end
    end
    context 'when called with user argument' do
      let(:user) { create :user }

      subject { event.progress_bar user }

      context 'when user not part of event yet' do
        let(:event) { create :event, :with_shift }

        it 'returns a public progress bar' do
          expect(subject).to be_a ProgressBar::Public
        end
      end
      context 'when user part of upcoming shift' do
        let(:event) { create :event, :skip_validate }
        let(:shift) { create :shift, event: event }
        let!(:participation) { create :participation, shift: shift, user: user }

        it 'returns a private progress bar' do
          expect(subject).to be_a ProgressBar::Personal
        end
      end
    end
  end
end
