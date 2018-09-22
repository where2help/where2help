require 'rails_helper'

RSpec.describe OngoingEvent, type: :model do
  it { is_expected.to act_as_paranoid }
  it { is_expected.to belong_to :ngo }

  describe 'validations' do
    it { expect(create(:ongoing_event)).to be_valid }

    it { is_expected.to validate_presence_of :address }
    it { is_expected.to validate_presence_of :contact_person }
    it { is_expected.to validate_presence_of :ongoing_event_category }
    it { is_expected.to validate_length_of :title }
    it { is_expected.to belong_to(:ongoing_event_category) }
  end

  describe 'scopes' do
    let(:full_event) { create :ongoing_event, :published }
    let(:third_event) { create :ongoing_event, :published }
    let(:second_event) { create :ongoing_event, :published }
    let(:first_event) { create :ongoing_event, :published }
    subject(:events) { OngoingEvent.all }

    describe '.published' do
      let!(:published_events) { create_list :ongoing_event, 3, :published }
      let!(:unpublished) { create :ongoing_event }

      context '.published' do
        subject { described_class.published }

        it 'returns only events with published_at set' do
          expect(subject).to match_array published_events
        end

        it 'ignores records without published_at date' do
          expect(subject).not_to include unpublished
        end
      end
    end
  end

  describe '#volunteers_needed and #volunteers_count' do
    context 'when upcoming shifts' do
      let(:event) { create :ongoing_event, volunteers_needed: 20, volunteers_count: 10 }

      it 'sums up all available_shifts volunteers_needed' do
        expect(event.volunteers_needed).to eq 20
      end

      it 'sums up all available_shifts volunteers_count' do
        expect(event.volunteers_count).to eq 10
      end
    end
  end

  describe '#state' do
    it 'returns "deleted" if soft deleted' do
      event = create(:ongoing_event, deleted_at: Time.now)
      expect(event.state).to eq 'deleted'
    end

    it 'returns "published" if published and not soft deleted' do
      event = create(:ongoing_event, :published)
      expect(event.state).to eq 'published'
    end
  end

  describe '#publish!' do
    context 'when not published yet' do
      let!(:event) { create(:ongoing_event) }

      it 'adds published_at timestamp' do
        expect {
          event.publish!
          event.reload
        }.to change { event.published_at }
      end
    end
    context 'when already published' do
      let!(:event) { create(:ongoing_event, published_at: 2.days.ago) }

      it 'does not update the record' do
        expect {
          event.publish!
          event.reload
        }.not_to change { event.published_at.to_i }
      end
    end
  end
end
