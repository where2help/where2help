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
    context 'with valid params' do
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
    end
  end
end
