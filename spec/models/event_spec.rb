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
end
