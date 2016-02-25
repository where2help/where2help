require 'rails_helper'

RSpec.describe Ngo, type: :model do

  it 'has a valid factory' do
    expect(create :ngo).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :identifier }
    it { is_expected.to validate_presence_of :contact }
  end

  it { is_expected.to define_enum_for(:locale).with([:de, :en])}

  describe 'associations' do
    let(:ngo) { create :ngo }

    describe 'contact' do
      it { is_expected.to have_one :contact }

      it 'destroys contact on destroy' do
        create :contact, ngo: ngo
        expect{
          ngo.destroy
        }.to change{Contact.count}.by -1
      end
    end
  end
end
