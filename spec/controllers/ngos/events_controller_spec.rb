require 'rails_helper'

RSpec.describe Ngos::EventsController, type: :controller do

  before do
    @request.env['devise.mapping'] = Devise.mappings[:ngo]
  end

  describe "GET index" do
    let(:ngo) { create :ngo, :confirmed }
    let(:other_ngo) { create :ngo, :confirmed }
    let(:other_event) { create(:event, :with_shift, ngo: other_ngo) }
    let(:own_events) { create_list(:event, 4, :with_shift, ngo: ngo) }

    context 'not signed in' do
      it 'redirects to ngo sign_in' do
        get :index
        expect(response).to redirect_to new_ngo_session_path
      end
    end
    context 'given a signed in NGO' do
      before do
        sign_in :ngo, ngo
      end

      it "@events includes the signed in ngo's events" do
        get :index
        expect(assigns(:events)).to match_array(own_events)
      end
      it "@events does not include the other ngo's events" do
        get :index
        expect(assigns(:events)).to_not include(other_event)
      end
    end
  end

  describe 'GET show' do
    context 'when not signed in' do
      it 'redirects to ngo sign_in' do
        get :show, params: { id: 1 }
        expect(response).to redirect_to new_ngo_session_path
      end
    end
    context 'given a signed in NGO' do
      let(:ngo) { create :ngo, :confirmed }

      before { sign_in ngo }

      context 'when owning the event' do
        let(:event) { create :event, :with_shift, ngo: ngo }

        before { get :show, params: { id: event } }

        it 'assigns @event' do
          expect(assigns :event).to eq event
        end
        it 'renders :show' do
          expect(response).to render_template 'ngos/events/show'
        end
      end
      context 'when not owning the event' do
        let(:event) { create :event, :with_shift }

        it 'raises ActiveRecord::RecordNotFound' do
          expect{
            get :show, params: { id: event }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "GET new" do
    context 'not signed in' do
      it 'redirects to ngo sign_in' do
        get :new
        expect(response).to redirect_to new_ngo_session_path
      end
    end
    context 'given a signed in NGO' do
      before do
        sign_in :ngo, FactoryGirl.create(:ngo, :confirmed)
      end

      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    context 'given a signed in user' do
      before do
        sign_in :user, FactoryGirl.create(:user)
      end

      it "redirects to the NGO sign in page" do
        get :new
        expect(response).to redirect_to(new_ngo_session_path)
      end
    end
  end

  describe 'POST create' do
    context 'when signed in as user' do
      before { sign_in create(:user) }

      it 'redirects to ngo login with flash' do
        post :create, params: {}
        expect(response).to redirect_to new_ngo_session_path
        expect(flash[:alert]).to be_present
      end
    end
    context 'when signed in as NGO' do
      let(:ngo) { create :ngo, :confirmed }

      before { sign_in ngo }

      context 'with invalid params' do
        let(:params) {{event: {title: ''}}}
        it 'does not create new event record' do
          expect{
            post :create, params: params
          }.not_to change{Event.count}
        end
        it 'assigns @event' do
          post :create, params: params
          expect(assigns :event).to be
        end
        it 'assigns @event the current signed in ngo' do
          post :create, params: params
          expect(assigns(:event).ngo).to eq(ngo)
        end
        it 'renders :new' do
          post :create, params: params
          expect(response).to render_template :new
        end
      end
      context 'with valid params' do
        let(:params) {{ event: {
          title: 'event title',
          description: 'huge event description',
          address: 'street with number',
          shifts_attributes: [ { volunteers_needed: "1",
                                 starts_at: Time.now + 2.hours,
                                 ends_at: Time.now + 4.hours,
                                 volunteers_needed: 1,
                                 volunteers_count: 0 } ] }}}

        it 'creates new event record' do
          expect{
            post :create, params: params
          }.to change{Event.count}.by 1
        end
        it 'redirects to @event' do
          post :create, params: params
          expect(response).to redirect_to [:ngos, assigns(:event)]
        end
      end
    end
  end

  describe 'GET edit' do
    context 'when not signed in' do
      it 'redirects to ngo sign_in' do
        get :edit, params: { id: 1 }
        expect(response).to redirect_to new_ngo_session_path
      end
    end
    context 'given a signed in NGO' do
      let(:ngo) { create :ngo, :confirmed }

      before { sign_in ngo }

      context 'when owning the event' do
        let(:event) { create :event, :with_shift, ngo: ngo }

        before { get :edit, params: { id: event } }

        it 'assigns @event' do
          expect(assigns :event).to eq event
        end
        it 'renders :edit' do
          expect(response).to render_template 'ngos/events/edit'
        end
      end
      context 'when not owning the event' do
        let(:event) { create :event, :with_shift }

        it 'raises ActiveRecord::RecordNotFound' do
          expect{
            get :show, params: { id: event }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'PUT update' do
    context 'when not signed in' do
      it 'redirects to ngo sign_in' do
        put :update, params: { id: 1 }
        expect(response).to redirect_to new_ngo_session_path
      end
    end
    context 'given a signed in NGO' do
      let(:ngo) { create :ngo, :confirmed }
      let(:params) {{ id: event, event: { title: 'whatever' } }}

      before { sign_in ngo }

      context 'when owning the event' do
        let(:event) { create :event, :with_shift, ngo: ngo }

        before do
          put :update, params: params
          event.reload
        end

        it 'assigns @event' do
          expect(assigns :event).to eq event
        end
        it 'updates attributes' do
          expect(event).to have_attributes(title: 'whatever')
        end
        it 'redirects to event' do
          expect(response).to redirect_to [:ngos, event]
        end
      end
      context 'when not owning the event' do
        let(:event) { create :event, :with_shift }

        it 'raises ActiveRecord::RecordNotFound' do
          expect{
            put :update, params: params
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'DELETE destroy' do
    context 'when not signed in' do
      it 'redirects to ngo sign_in' do
        delete :destroy, params: { id: 1 }
        expect(response).to redirect_to new_ngo_session_path
      end
    end
    context 'given a signed in NGO' do
      let(:ngo) { create :ngo, :confirmed }
      let(:params) {{ id: event }}

      before { sign_in ngo }

      context 'when owning the event' do
        let!(:event) { create :event, :with_shift, ngo: ngo }

        it 'destroys event' do
          expect{
            delete :destroy, params: params
          }.to change{Event.count}.by -1
        end
        it 'redirects to index' do
          delete :destroy, params: params
          expect(response).to redirect_to ngos_events_path
        end
      end
      context 'when not owning the event' do
        let(:event) { create :event, :with_shift }

        it 'raises ActiveRecord::RecordNotFound' do
          expect{
            delete :destroy, params: params
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'POST publish' do
    context 'when not signed in' do
      it 'redirects to ngo sign_in' do
        post :publish, params: { id: 1 }
        expect(response).to redirect_to new_ngo_session_path
      end
    end
    context 'given a signed in NGO' do
      let(:ngo) { create :ngo, :confirmed }
      let(:params) {{ id: event }}

      before { sign_in ngo }

      context 'when owning the event' do
        let(:event) { create :event, :with_shift, ngo: ngo }

        it 'updates event state to published' do
          expect{
            post :publish, params: params
            event.reload
          }.to change{event.state}.to 'published'
        end
        it 'redirects to event' do
          post :publish, params: params
          expect(response).to redirect_to [:ngos, event]
        end
      end
      context 'when not owning the event' do
        let(:event) { create :event, :with_shift }

        it 'raises ActiveRecord::RecordNotFound' do
          expect{
            post :publish, params: params
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
