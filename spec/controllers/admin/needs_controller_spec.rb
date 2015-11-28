require 'rails_helper'

RSpec.describe Admin::NeedsController, type: :controller do
  before { create(:admin) }

  describe 'GET index' do
    context 'when not signed in' do
      before { get :index }

      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in as volunteer' do
      before do
        sign_in create(:user, ngo_admin: false, admin: false)
        get :index
      end

      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in as ngo_admin' do
      before do
        sign_in create(:ngo)
        get :index
      end

      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in as admin' do
      let(:admin) { create :admin }
      before do
        sign_in admin
        get :index
      end

      it 'assigns @needs' do
        expect(assigns :needs).to be
      end

      it 'renders :index' do
        expect(response).to render_template('admin/needs/index')
      end
    end
  end

  describe 'GET edit' do
    let(:need) { create :need }
    context 'when not signed in' do
      before { get :edit, id: create(:need) }

      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in as volunteer' do
      before do
        sign_in create(:user, ngo_admin: false, admin: false)
        get :edit, id: need
      end

      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in as ngo_admin' do
      before do
        sign_in create(:ngo)
        get :edit, id: need
      end

      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in as admin' do
      let(:admin) { create :admin }
      before do
        sign_in admin
        get :edit, id: need
      end

      it 'assigns @need' do
        expect(assigns :need).to eq need
      end

      it 'renders :edit' do
        expect(response).to render_template('admin/needs/edit')
      end
    end
  end

  describe 'PUT update' do
    let(:need) { create :need }
    context 'when not signed in' do
      before { put :update, id: need.id, need: need.attributes }

      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in as volunteer' do
      before do
        sign_in create(:user, ngo_admin: false, admin: false)
        put :update, id: need.id, need: need.attributes
      end

      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in as ngo_admin' do
      before do
        sign_in create(:ngo)
        patch :update, id: need.id, need: need.attributes
      end

      it_behaves_like :an_unauthorized_request
    end

    context 'when signed in as admin', job: true do
      let(:admin) { create :admin }
      let(:ngo) { create :ngo }
      let(:params) {
        {
          need: {
            user_id: ngo.id,
            location: 'somewhere',
            city: 'some city',
            description: 'lorem',
          }, id: need
        }
      }
      before do
        sign_in admin
        put :update, params
        need.reload
      end

      it 'assigns @need' do
        expect(assigns :need).to eq need
      end

      it 'updates attributes' do
        expect(need).to have_attributes(
          user: ngo,
          location: 'somewhere',
          city: 'some city',
          description: 'lorem')
      end

      it 'renders :index' do
        expect(response).to redirect_to action: :index,
                                        locale: 'de',
                                        notice: 'Need was successfully updated.'
      end
    end
  end
end
