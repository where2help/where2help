# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ngos::RegistrationsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:ngo] }

  describe 'GET new' do
    it 'return 200 ok status' do
      get :new
      expect(response).to have_http_status 200
    end
  end

  describe 'POST create' do
    context 'with valid attributes' do
      let(:params) {
        {
          ngo: attributes_for(:ngo, email: 'ngo@ngo.we').merge(
            password: 'supersecret',
            password_confirmation: 'supersecret',
            terms_and_conditions: 1,
            contact_attributes: attributes_for(:contact)
          )
        }
      }

      it 'returns a 302 found response' do
        post :create, params: params
        expect(response).to have_http_status 302
      end

      it 'creates new ngo record' do
        expect{
          post :create, params: params
        }.to change{ Ngo.count }.by 1
      end

      it 'creates new contact record' do
        expect{
          post :create, params: params
        }.to change{ Contact.count }.by 1
      end

      it 'sends email to ngo' do
        Devise::Mailer.deliveries.clear
        post :create, params: params
        expect(Devise::Mailer.deliveries.count).to eq 1
        expect(Devise::Mailer.deliveries.first.to).to contain_exactly 'ngo@ngo.we'
        Devise::Mailer.deliveries.clear
      end

      it 'sends async email to admins' do
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
          ngo: attributes_for(:ngo, email: 'ngo@ngo.at').merge(
            password: 'supersecret',
            password_confirmation: 'supersecret'
          )
        }
      }

      it 'returns a 200 ok status' do
        post :create, params: params
        expect(response).to have_http_status 200
      end

      it 'does not create new ngo record' do
        expect{
          post :create, params: params
        }.not_to change{ Ngo.count }
      end
    end
  end

  describe 'PUT update' do
    let(:ngo) { create :ngo, :confirmed }

    before do
      sign_in ngo, scope: :ngo
      put :update, params: params
      ngo.reload
    end

    context 'with current password provided' do
      let(:params) do
        {
          ngo: attributes_for(:ngo, current_password: ngo.password)
            .merge(contact_attributes: attributes_for(:contact))
        }
      end

      it 'updates profile and contact of the NGO', skip: "this test fails indeterministicly" do
        expect(ngo.email).to eq(params[:ngo][:email])
        expect(ngo.name).to eq(params[:ngo][:name])
        contact = ngo.contact.reload
        expect(contact.first_name).to eq(params[:ngo][:contact_attributes][:first_name])
        expect(contact.last_name).to eq(params[:ngo][:contact_attributes][:last_name])
      end

      it 'redirects to :edit with :notice flash' do
        expect(response).to redirect_to edit_ngo_registration_path
        expect(flash[:notice]).to be_present
      end
    end
    context 'without current password' do
      let(:params) { { ngo: attributes_for(:ngo, current_password: '') } }

      it 'renders :edit without :notice flash' do
        expect(response).to render_template :edit
        expect(flash[:notice]).not_to be_present
      end

      it 'does not change any attributes' do
        expect(ngo.email).not_to eq params[:ngo][:email]
      end
    end
  end

  describe 'DELETE destroy' do
    let(:ngo) { create(:ngo, :confirmed) }

    before { sign_in ngo }

    subject { delete :destroy }

    context 'when already created event' do
      before { create(:event, :with_shift, ngo: ngo) }

      it 'does not delete account' do
        expect { subject }.not_to change { Ngo.count }
      end

      it 'renders :edit' do
        subject
        expect(response).to render_template :edit
      end
    end
    context 'when no events created yet' do
      it 'soft deletes account' do
        expect { subject }.to change { Ngo.count }
      end

      it 'redirects to root' do
        subject
        expect(response).to redirect_to root_url
      end
    end
  end
end
