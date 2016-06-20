require 'rails_helper'

RSpec.describe User, type: :model do

  it 'has a valid factory' do
    expect(create :user).to be_valid
  end

  it { is_expected.to have_many(:languages_users).dependent(:destroy) }
  it { is_expected.to have_many(:languages) }
  it { is_expected.to have_many(:abilities_users).dependent(:destroy) }
  it { is_expected.to have_many(:abilities) }
  it { is_expected.to have_many(:shifts_users).dependent(:destroy) }
  it { is_expected.to have_many(:shifts) }
  it { is_expected.to define_enum_for(:locale).with([:de, :en]) }

  describe 'validations' do
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_length_of :first_name }
    it { is_expected.to validate_length_of :last_name }
    it { is_expected.to validate_acceptance_of :terms_and_conditions }
  end

  describe 'attributes' do
    let(:user) { build :user }

    it 'can be admin (default false)' do
      expect(user.admin).to be_falsy
    end
  end
end
