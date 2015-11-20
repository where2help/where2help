require 'rails_helper'

RSpec.describe Admin::NeedsController, type: :controller do
  before { create(:admin) }
  describe 'GET index' do
    context 'when not signed in' do
      context 'when html request' do
        before { get :index }

        it_behaves_like :an_unauthorized_request
      end
    end

    context 'when signed in as volunteer' do
      let(:user) { create(:user, ngo_admin: false, admin: false) }
      before do
        sign_in user
        get :index
      end

      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in as ngo_admin' do
      let(:ngo) { create(:ngo) }
      before do
        sign_in ngo
        get :index
      end

      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in as admin' do
      let(:admin) { create(:admin) }
      before do
        sign_in admin
        get :index
      end

      it 'renders :index' do
        expect(response).to render_template('admin/needs/index')
      end
    end
  end
end
