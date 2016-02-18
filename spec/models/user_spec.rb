require 'rails_helper'

RSpec.describe User, type: :model do

  it 'has a valid factory' do
    expect(create :user).to be_valid
  end

  describe 'validations' do
    it 'is invalid without email' do
      expect(build :user, email: nil).not_to be_valid
    end
    it 'is invalid without first_name' do
      expect(build :user, first_name: nil).not_to be_valid
    end

    it 'is invalid without last_name' do
      expect(build :user, last_name: nil).not_to be_valid
    end
  end
end
