require 'rails_helper'

RSpec.describe User, type: :model do

  it 'has a valid factory' do
    expect(create :user).to be_valid
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_length_of :first_name }
    it { is_expected.to validate_length_of :last_name }
  end

  describe 'attributes' do
    let(:user) { build :user }

    it 'can be admin (default false)' do
      expect(user.admin).to be_falsy
    end
  end
end
