require 'rails_helper'
require 'models/shared/progress_bar'

RSpec.describe ProgressBar::Personal, type: :model do
  describe 'attributes' do
    subject { described_class.new parent }

    context 'when parent is Shift' do
      let(:parent) {
        create :shift, :with_event, volunteers_needed: 10, volunteers_count: 2
      }

      it_behaves_like :a_personal_bar
    end
    context 'when parent is Event' do
      let(:parent) { create :event, :skip_validate }
      before do
        create :shift, event: parent, volunteers_needed: 10, volunteers_count: 2
      end

      it_behaves_like :a_personal_bar
    end
  end
end
