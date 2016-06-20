require 'rails_helper'

RSpec.describe Language, type: :model do
  it 'has a valid factory' do
    expect(create :language).to be_valid
  end
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to have_many(:languages_users).dependent(:destroy) }
  it { is_expected.to have_many(:users) }

  describe 'callbacks' do
    let(:language) { create :language }

    describe 'users' do
      let(:user) { create :user }
      
      before { language.users << user }

      it 'destroys join record on destroy' do
        expect{
          language.destroy
        }.to change{LanguagesUser.count}.by -1
      end
      it 'does not destroy user record on destroy' do
        expect{
          language.destroy
        }.not_to change{User.count}
      end
    end
  end
end
