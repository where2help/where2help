require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:ngo) { build :ngo }

  it { is_expected.to act_as_paranoid }

  describe 'validations' do
    it { expect(build(:contact, ngo: ngo)).to be_valid }

    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_length_of :first_name }
    it { is_expected.to validate_length_of :last_name }
    it { is_expected.to validate_presence_of :phone }
    it { is_expected.to validate_presence_of :street }
    it { is_expected.to validate_presence_of :zip }
    it { is_expected.to validate_presence_of :city }
  end
end
