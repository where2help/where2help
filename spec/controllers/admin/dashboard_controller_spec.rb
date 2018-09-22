require 'rails_helper'

RSpec.describe Admin::DashboardController, type: :controller do
  describe 'GET index' do
    context 'when logged out' do
      it 'returns a 302 redirect' do
        get :index
        expect(response).to have_http_status 302
      end
    end
    context 'when logged in as normal user' do
      before { sign_in create(:user) }

      it 'returns a 302 found response' do
        get :index
        expect(response).to have_http_status 302
      end
    end
    context 'when logged in as admin user' do
      before { sign_in create(:user, admin: true) }

      it 'returns a 200 ok response' do
        get :index
        expect(response).to have_http_status 200
      end
    end
  end
end
