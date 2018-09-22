require 'rails_helper'

RSpec.describe Ability, type: :model do
  it 'has a valid factory' do
    expect(create(:ability)).to be_valid
  end
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to have_many(:qualifications).dependent(:destroy) }
  it { is_expected.to have_many(:users) }

  describe 'callbacks' do
    let(:ability) { create :ability }

    describe 'users' do
      let(:user) { create :user }

      before { ability.users << user }

      it 'destroys join record on destroy' do
        expect do
          ability.destroy
        end.to change { Qualification.count }.by -1
      end
      it 'does not destroy user record on destroy' do
        expect do
          ability.destroy
        end.not_to change { User.count }
      end
    end
  end
end
