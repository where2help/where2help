require 'rails_helper'

RSpec.describe Ngo, type: :model do

  it { is_expected.to have_one(:contact).dependent :destroy }
  it { is_expected.to define_enum_for(:locale).with([:de, :en]) }
  it { is_expected.to act_as_paranoid }

  describe 'validations' do
    it { expect(create :ngo).to be_valid }
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :contact }
    it { is_expected.to validate_acceptance_of :terms_and_conditions }
    it { is_expected.to have_many(:events).dependent(:restrict_with_error) }
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
    describe 'contact' do
      let(:ngo) { create :ngo }

      it 'destroys contact record on destroy' do
        create(:contact, ngo: ngo)
        expect{
          ngo.destroy
        }.to change{Contact.count}.by -1
      end
    end
  end

  describe '#confirm!' do
    before { ActiveJob::Base.queue_adapter = :test }

    context 'when not confirmed by admin' do
      let!(:ngo) { create(:ngo) }

      it 'adds an admin_confirmed_at timestamp' do
        expect {
          ngo.confirm!
          ngo.reload
        }.to change { ngo.admin_confirmed_at }
      end

      it 'send confirmation email to ngo' do
        expect{ ngo.confirm! }.to have_enqueued_job(ActionMailer::DeliveryJob)
      end
    end
    context 'when already confirmed by admin' do
      let!(:ngo) { create(:ngo, admin_confirmed_at: Time.now) }

      it 'does not update the record' do
        expect {
          ngo.confirm!
          ngo.reload
        }.not_to change { ngo.admin_confirmed_at }
      end

      it 'does not send an email' do
        expect{ ngo.confirm! }.not_to have_enqueued_job(ActionMailer::DeliveryJob)
      end
    end
  end

  describe '#state' do
    it 'returns "pending" by default' do
      ngo = create(:ngo)
      expect(ngo.state).to eq 'pending'
    end

    it 'returns "deleted" if soft deleted' do
      ngo = create(:ngo, :confirmed, deleted_at: Time.now)
      expect(ngo.state).to eq 'deleted'
    end

    it 'returns "confirmed" if admin_confirmed and not soft deleted' do
      ngo = create(:ngo, :confirmed)
      expect(ngo.state).to eq 'confirmed'
    end
  end

  describe '#new_event' do
    let(:ngo) { create :ngo, :confirmed }
    subject{ ngo.new_event }

    it 'retuns an event with one shift' do
      expect(subject).to be_a_new Event
    end
    it 'has a shift at next quarter hour with 1 volunteer needed' do
      shift = subject.shifts.first
      expect(shift.volunteers_needed).to eq 1
      expect([0, 15, 30, 45]).to include shift.starts_at.min
      expect([0, 15, 30, 45]).to include shift.ends_at.min
    end
  end
end
