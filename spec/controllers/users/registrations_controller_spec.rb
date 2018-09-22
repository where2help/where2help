# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'PUT update' do
    let(:user) { create :user }

    before do
      sign_in user, scope: :user
      put :update, params: params
      user.reload
    end

    context 'with current password provided' do
      let(:params) { { user: attributes_for(:user, current_password: user.password) } }

      it 'updates the profile' do
        expect(user.email).to eq(params[:user][:email])
        expect(user.first_name).to eq(params[:user][:first_name])
      end

      it 'redirects to :edit with :notice flash' do
        expect(response).to redirect_to edit_user_registration_path
        expect(flash[:notice]).to be_present
      end
    end
    context 'without current password' do
      let(:params) { { user: attributes_for(:user, current_password: '') } }

      it 'renders :edit without :notice flash' do
        expect(response).to render_template :edit
        expect(flash[:notice]).not_to be_present
      end

      it 'does not change any attributes' do
        expect(user.email).not_to eq params[:user][:email]
      end
    end
  end
end
