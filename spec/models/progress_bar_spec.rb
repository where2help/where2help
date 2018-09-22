require 'rails_helper'

RSpec.describe ProgressBar, type: :model do
  describe '#items' do
    subject { progress_bar.items }

    context 'without offset' do
      shared_examples :a_progress_bar_with_two_items do
        it 'returns an Array of two Items' do
          items = subject
          expect(subject).to be_a Array
          expect(subject.size).to eq 2
          expect(subject).to all be_a ProgressBar::Item
        end
      end
      context 'when no progress yet' do
        let(:progress_bar) { described_class.new(progress: 0, total: 10) }

        it_behaves_like :a_progress_bar_with_two_items

        it 'contains a :progress and a :rest item' do
          expect(subject.map(&:type)).to eq [:progress, :rest]
          expect(subject.map(&:width)).to eq [0, 100]
        end
      end
      context 'when some progress' do
        let(:progress_bar) { described_class.new(progress: 8, total: 10) }

        it_behaves_like :a_progress_bar_with_two_items

        it 'contains a :progress and a :rest item' do
          expect(subject.map(&:type)).to eq [:progress, :rest]
          expect(subject.map(&:width)).to eq [80, 20]
        end
      end
      context 'when total progess' do
        let(:progress_bar) { described_class.new(progress: 10, total: 10) }

        it_behaves_like :a_progress_bar_with_two_items

        it 'contains a :progress and a :rest item' do
          expect(subject.map(&:type)).to eq [:progress, :rest]
          expect(subject.map(&:width)).to eq [100, 0]
        end
      end
      context 'when surplus' do
        let(:progress_bar) { described_class.new(progress: 10, total: 2) }

        it_behaves_like :a_progress_bar_with_two_items

        it 'contains a :progress and a :full item' do
          expect(subject.map(&:type)).to eq [:progress, :full]
          expect(subject.map(&:width)).to eq [20, 80]
        end
      end
    end
    context 'with offset' do
      shared_examples :a_progress_bar_with_three_items do
        it 'returns an Array of two Items' do
          items = subject
          expect(subject).to be_a Array
          expect(subject.size).to eq 3
          expect(subject).to all be_a ProgressBar::Item
        end
      end
      context 'when only offset progress' do
        let(:progress_bar) { described_class.new(progress: 1, total: 10, offset: 1) }

        it_behaves_like :a_progress_bar_with_three_items

        it 'contains an :offset, :progress and :rest item' do
          expect(subject.map(&:type)).to eq [:offset, :progress, :rest]
          expect(subject.map(&:width)).to eq [10, 0, 90]
        end
      end
      context 'when some progress' do
        let(:progress_bar) { described_class.new(progress: 3, total: 10, offset: 1) }

        it_behaves_like :a_progress_bar_with_three_items

        it 'contains an :offset, :progress and :rest item' do
          expect(subject.map(&:type)).to eq [:offset, :progress, :rest]
          expect(subject.map(&:width)).to eq [10, 20, 70]
        end
      end
      context 'when total progess' do
        let(:progress_bar) { described_class.new(progress: 10, total: 10, offset: 1) }

        it_behaves_like :a_progress_bar_with_three_items

        it 'contains an :offset, :progress and :rest item' do
          expect(subject.map(&:type)).to eq [:offset, :progress, :rest]
          expect(subject.map(&:width)).to eq [10, 90, 0]
        end
      end
      context 'when surplus' do
        let(:progress_bar) { described_class.new(progress: 10, total: 2, offset: 1) }

        it_behaves_like :a_progress_bar_with_three_items

        it 'contains an :offset, :progress and :rest item' do
          expect(subject.map(&:type)).to eq [:offset, :progress, :full]
          expect(subject.map(&:width)).to eq [10, 10, 80]
        end
      end
    end
  end
end
