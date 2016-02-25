require 'rails_helper'

RSpec.describe Ngos::RegistrationsController, type: :controller do
  before do
    @request.env['devise.mapping'] = Devise.mappings[:ngo]
  end

  describe 'GET new' do
    it 'return success' do
      get :new
      expect(response).to have_http_status :success
    end
  end

  describe 'POST create' do
    context 'with valid attributes' do
      let(:params) {
        {
          ngo: attributes_for(:ngo, email: 'ngo@ngo.at').merge({
            password: 'supersecret',
            password_confirmation: 'supersecret',
            contact_attributes: attributes_for(:contact)})
        }
      }

      it 'returns 302' do
        post :create, params: params
        expect(response).to have_http_status 302
      end

      it 'creates new ngo record' do
        expect{
          post :create, params: params
        }.to change{Ngo.count}.by 1
      end

      it 'creates new contact record' do
        expect{
          post :create, params: params
        }.to change{Contact.count}.by 1
      end

      it 'send email to ngo' do
        ActionMailer::Base.deliveries.clear
        post :create, params: params
        expect(ActionMailer::Base.deliveries.count).to eq 1
        expect(ActionMailer::Base.deliveries.first.to).to contain_exactly 'ngo@ngo.at'
        ActionMailer::Base.deliveries.clear
      end

      it 'sends email to admins' do
        create :user, admin: true
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(AdminMailer).to receive(:new_ngo).and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)
        post :create, params: params
      end
    end
    context 'with missing attributes' do
      let(:params) {
        {
          ngo: attributes_for(:ngo, email: 'ngo@ngo.at').merge({
            password: 'supersecret',
            password_confirmation: 'supersecret'})
        }
      }

      it 'returns 200' do
        post :create, params: params
        expect(response).to have_http_status 200
      end

      it 'does not create new ngo record' do
        expect{
          post :create, params: params
        }.not_to change{Ngo.count}
      end
    end
  end
end
