# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IcalFile do
  describe 'attributes' do
    context 'when initialized with event' do
      let(:event) { build :event, :with_shift }
      let(:ngo) { build :ngo }

      subject { described_class.new item: event, attendee: ngo }

      it 'has private attribute attendee' do
        expect(subject.send(:attendee)).to eq ngo
      end
      it 'has private attribute item' do
        expect(subject.send(:item)).to eq event
      end
      it 'has private attribute title' do
        expect(subject.send(:title)).to eq event.title
      end
      it 'has private attribute desc' do
        expect(subject.send(:desc)).to eq event.description
      end
      it 'has private attribute address' do
        expect(subject.send(:address)).to eq event.address
      end
    end
    context 'when initialized with shift' do
      let(:event) { build :event }
      let(:shift) { build :shift, event: event }
      let(:user) { build :user }

      subject { described_class.new item: shift, attendee: user }

      it 'has private attribute attendee' do
        expect(subject.send(:attendee)).to eq user
      end
      it 'has private attribute item' do
        expect(subject.send(:item)).to eq shift
      end
      it 'has private attribute title from event' do
        expect(subject.send(:title)).to eq event.title
      end
      it 'has private attribute desc from event' do
        expect(subject.send(:desc)).to eq event.description
      end
      it 'has private attribute address from event' do
        expect(subject.send(:address)).to eq event.address
      end
    end
    context 'when initialized with other item' do
      it 'raises an exception' do
        expect{
          described_class.new item: []
        }.to raise_error ArgumentError
      end
    end
  end

  describe '#call' do
    let(:event) { create :event, :with_shift }
    let(:service) { described_class.new item: event }

    subject { service.call }

    it 'returns an ical string' do
      expect(subject).to be_a String
    end
  end

  describe '.call' do
    let(:event) { create :event, :with_shift }
    subject { described_class.call item: event }

    it 'initializes new IcalFile and calls it' do
      expect(subject).to be_a String
    end
  end
end
