require 'rails_helper'

RSpec.describe Language, type: :model do
  it 'has a valid factory' do
    expect(create :language).to be_valid
  end
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to have_many(:languages_users).dependent(:destroy) }
  it { is_expected.to have_many(:users) }
end
