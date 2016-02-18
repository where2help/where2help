require 'rails_helper'

RSpec.describe Contact, type: :model do
  it 'has a valid factory' do
    expect(create :contact).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_length_of :first_name }
    it { is_expected.to validate_length_of :last_name }
    it { is_expected.to validate_presence_of :phone }
    it { is_expected.to validate_presence_of :street }
    it { is_expected.to validate_presence_of :zip }
    it { is_expected.to validate_presence_of :city }
  end
end
