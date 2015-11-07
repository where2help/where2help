require 'rails_helper'

RSpec.describe Ngos::RegistrationsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'GET new' do
    before { get :new }

    it 'assigns @user' do
      expect(assigns(:user)).to be_an_instance_of(User)
    end

    it 'renders ngos/registrations/new' do
      expect(response).to render_template('ngos/registrations/new')
    end
  end

  describe 'POST create', job: true do
    let!(:admin) { create(:user, admin: true) } # Admin user to send mail to

    context 'with valid params' do
      let(:params) {
        {
          user: attributes_for(:user).merge({
            organization: 'ngo club',
            password: 'supersecret',
            password_confirmation: 'supersecret'})
        }
      }

      it 'creates new user record' do
        expect{
          post :create, params
        }.to change(User, :count).by(1)
      end

      it 'sends email to admin' do
        expect{
          post :create, params
        }.to change(ActionMailer::Base.deliveries, :size).by(1)
      end

      it 'redirects to root with flash' do
        post :create, params
        expect(response).to redirect_to root_path
        expect(flash[:notice]).not_to be_empty
      end

      describe 'new user' do
        before { post :create, params }
        subject(:user) { User.last }

        it 'is ngo_admin' do
          expect(user.ngo_admin).to be true
        end

        it 'is unconfirmed' do
          expect(user.admin_confirmed).to eq false
        end
      end
    end

    context 'with invalid params' do
      let(:params) {
        {
          user: attributes_for(:user).merge({
            organization: 'ngo club',
            password: 'supersecret',
            password_confirmation: 'supersecret'})
        }
      }
      context 'without organization name' do
        before { params.deep_merge!({ user: { organization: nil } }) }

        it 'does not create new user record' do
          expect{
            post :create, params
          }.not_to change{User.count}
        end

        it 'does not send email to admin' do
          expect{
            post :create, params
          }.not_to change{ActionMailer::Base.deliveries.size}
        end

        it 'renders form again' do
          post :create, params
          expect(response).to render_template('ngos/registrations/new')
        end
      end
    end
  end
end
