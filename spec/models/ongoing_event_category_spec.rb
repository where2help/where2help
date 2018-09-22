require 'rails_helper'

RSpec.describe OngoingEventCategory, type: :model do
  it 'has a valid factory' do
    expect(create :ongoing_event_category).to be_valid
  end
  it { is_expected.to validate_presence_of :name_en }
  it { is_expected.to validate_presence_of :name_de }
  it { is_expected.to validate_uniqueness_of :name_en }
  it { is_expected.to validate_uniqueness_of :name_de }
  it { is_expected.to have_many(:ongoing_events).dependent(:restrict_with_error) }

  describe '#name' do
    let(:ongoing_event_category) { create :ongoing_event_category }

    it 'returns english name if locale is english' do
      I18n.with_locale(:en) do
        expect(ongoing_event_category.name).to eq ongoing_event_category.name_en
      end
    end
    it 'returns german name if locale is german' do
      I18n.with_locale(:de) do
        expect(ongoing_event_category.name).to eq ongoing_event_category.name_de
      end
    end
  end

  describe 'scopes' do
    describe '.ordered' do
      let!(:ordinal5) { create :ongoing_event_category, ordinal: 5 }
      let!(:ordinal1) { create :ongoing_event_category, ordinal: 1 }
      let!(:ordinal9) { create :ongoing_event_category, ordinal: 9 }

      subject(:ongoing_event_categories) { OngoingEventCategory.ordered }

      it 'sorts ongoing event categories by ordinal ascending' do
        expect(ongoing_event_categories.to_a).to eq [ordinal1, ordinal5, ordinal9]
      end
    end
  end
end
