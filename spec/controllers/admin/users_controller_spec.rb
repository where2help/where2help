require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  # Create first admin user
  let!(:admin) { create(:admin) }

  describe 'GET index' do
    context 'when not signed in' do
      before { get :index }

      it 'redirects to sign_in' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'renders sign_in page with flash' do
        expect(response).to render_template(session[:new])
        expect(flash[:alert]).to be_present
      end
    end

    context 'when signed in' do
      context 'when normal user' do
        let!(:user) { create(:user) }
        before do
          sign_in user
          get :index
        end

        it 'redirects to sign_in' do
          expect(response).to redirect_to(new_user_session_path)
        end

        it 'renders sign_in page with flash' do
          expect(response).to render_template(session[:new])
          expect(flash[:alert]).to be_present
        end
      end

      context 'when admin' do
        before do
          sign_in admin
          get :index
        end

        it 'assigns @users' do
          expect(assigns(:users)).to be
        end

        it 'renders /admin/users/index' do
          expect(response).to render_template('admin/users/index')
        end
      end
    end
  end
end
