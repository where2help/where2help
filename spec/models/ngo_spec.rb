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
    it { is_expected.to have_one(:contact).dependent :destroy }
  end

  describe 'callbacks' do
    describe 'after_commit' do
      before { create :user, admin: true }

      it 'sends email to admins' do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(AdminMailer).to receive(:new_ngo).and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)
        create :ngo
      end
    end
  end

  describe 'scopes' do
    let!(:unconfirmed) { create_list :ngo, 3, admin_confirmed_at: nil }
    let!(:confirmed) { create_list :ngo, 3, admin_confirmed_at: Time.now }

    describe '.unconfirmed' do
      subject(:scoped) { Ngo.unconfirmed }

      it 'returns non-admin confirmed records' do
        expect(scoped.ids).to match_array unconfirmed.map(&:id)
      end
    end
    describe '.confirmed' do
      subject(:scoped) { Ngo.confirmed }

      it 'returns non-admin confirmed records' do
        expect(scoped.ids).to match_array confirmed.map(&:id)
      end
    end
  end

  describe '#admin_confirm!' do
    let(:ngo) { create :ngo }

    it 'updates admin_confirmed_at value' do
      expect{
        ngo.admin_confirm!
      }.to change{ngo.admin_confirmed_at?}.from(false).to(true)
    end

    it 'sends email to ngo' do
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      expect(NgoMailer).to receive(:admin_confirmed).and_return(message_delivery)
      expect(message_delivery).to receive(:deliver_later)
      ngo.admin_confirm!
    end
  end
end
