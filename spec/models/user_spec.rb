require 'rails_helper'

RSpec.describe User, type: :model do

  it 'has a valid factory' do
    expect(build_stubbed(:need)).to be_valid
  end

  describe 'validations' do
    it 'is invalid without email' do
      expect(build(:user, email: nil)).not_to be_valid
    end

    it 'is invalid with dublicate email' do
      first_user = create(:user)
      expect(build(:user, email: first_user.email)).not_to be_valid
    end

    it 'is invalid without first_name' do
      expect(build(:user, first_name: nil)).not_to be_valid
    end

    it 'is invalid without last_name' do
      expect(build(:user, last_name: nil)).not_to be_valid
    end

    context 'when ngo_admin' do

      it 'is invalid without organization' do
        expect(build(:user, ngo_admin: true, organization: '')).not_to be_valid
      end
    end
  end
end
