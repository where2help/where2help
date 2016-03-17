require 'rails_helper'

RSpec.describe ShiftsController, type: :controller do
  describe 'GET index' do
    context 'when logged out' do
      it 'returns a 302 redirect' do
        get :index
        expect(response).to have_http_status 302
      end
    end
    context 'when logged in as ngo' do
      before do
        sign_in create(:ngo, :confirmed)
        get :index
      end

      it 'returns a 302 redirect' do
        expect(response).to have_http_status 302
      end
    end
    context 'when logged in as user' do
      before do
        sign_in create(:user)
        get :index
      end

      it 'returns a 200 success' do
        expect(response).to have_http_status 200
      end
    end
  end
end
