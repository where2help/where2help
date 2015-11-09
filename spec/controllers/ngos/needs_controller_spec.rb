require 'rails_helper'

RSpec.describe Ngos::NeedsController, type: :controller do
  # Create first admin user
  before { create(:admin) }

  describe 'GET calendar' do
    context 'when not signed in' do
      before { get :calendar }

      it 'redirects to sign_in' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'renders sign_in page with flash' do
        expect(response).to render_template(session[:new])
        expect(flash[:alert]).to be_present
      end
    end

    context 'when signed in as volunteer' do
      let(:user) { create(:user, ngo_admin: false, admin: false) }
      before do
        sign_in user
        get :calendar
      end

      it 'redirects to sign_in' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'renders sign_in page with flash' do
        expect(response).to render_template(session[:new])
        expect(flash[:alert]).to be_present
      end
    end

    context 'when signed in as ngo' do
      let(:ngo) { create(:ngo) }
      before do
        sign_in ngo
        get :calendar
      end

      it 'renders :calendar' do
        expect(response).to render_template('ngos/needs/calendar')
      end
    end
  end
end
