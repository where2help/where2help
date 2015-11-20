require 'rails_helper'

RSpec.describe Ngos::NeedsController, type: :controller do
  # Create first admin user
  before { create(:admin) }

  describe 'GET calendar' do
    context 'when not signed in' do
      before { get :calendar }

      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in as volunteer' do
      let(:user) { create(:user, ngo_admin: false, admin: false) }
      before do
        sign_in user
        get :calendar
      end

      it_behaves_like :an_unauthorized_request
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
