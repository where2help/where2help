require 'rails_helper'

RSpec.describe ShiftsController, type: :controller do
  describe 'GET index' do
    context 'when logged out' do
      it 'redirects to user sign_in' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in as ngo' do
      before do
        sign_in create(:ngo, :confirmed)
        get :index
      end

      it 'redirects to user sign_in' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in as user' do
      let(:shifts) { create_list :shift, 10 }
      before do
        sign_in create(:user)
        get :index
      end

      it 'assigns @shifts' do
        expect(assigns :shifts).to match_array shifts
      end

      it 'renders :index' do
        expect(response).to render_template :index
      end
    end
  end
end
