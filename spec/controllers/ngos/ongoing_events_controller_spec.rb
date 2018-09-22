# frozen_string_literal: true

require 'rails_helper'
require 'controllers/shared/ngos_controller'

RSpec.describe Ngos::OngoingEventsController, type: :controller do
  describe 'GET index' do
    it_behaves_like :ngos_index

    context 'given a signed in NGO' do
      let(:ngo) { create :ngo, :confirmed }

      before { sign_in ngo, scope: :ngo }

      context 'without events' do
        before { get :index }

        it 'assigns empty @events' do
          events = assigns :events
          expect(events.to_a).to be_empty
        end
        it 'renders :index' do
          expect(response).to render_template 'ngos/ongoing_events/index'
        end
      end
      context 'with events' do
        let!(:own_events) { create_list(:ongoing_event, 4, ngo: ngo) }

        context 'when no filter parameters given' do
          let(:other_ngo) { create :ngo, :confirmed }
          let!(:other_event) { create(:ongoing_event, ngo: other_ngo) }

          before { get :index }

          it "@events includes the signed in ngo's events" do
            events = (assigns :events)
            expect(events).to match_array own_events
          end
          it "@shifts does not include the other ngo's events" do
            expect(assigns(:events)).to_not include other_event
          end
          it 'renders :index' do
            expect(response).to render_template 'ngos/ongoing_events/index'
          end
        end
        context 'with valid order_by parameter' do
          let!(:last_event) { create(:ongoing_event, :skip_validate, ngo: ngo, title: 'A' * 100) }
          let(:params) { { order_by: 'title' } }

          before { get :index, params: params }

          it 'returns all filtered events' do
            events = (assigns :events)
            expect(events).to match_array ([last_event] + own_events)
          end
          it 'returns events ordered' do
            events = (assigns :events)
            expect(events.first).to eq last_event
          end
        end
      end
    end
  end

  describe 'GET show' do
    it_behaves_like :ngos_show

    context 'given a signed in NGO' do
      let(:ngo) { create :ngo, :confirmed }

      before { sign_in ngo, scope: :ngo }

      context 'when owning the event' do
        let(:event) { create :ongoing_event, ngo: ngo }

        before { get :show, params: { id: event } }

        it 'assigns @event' do
          expect(assigns(:event)).to eq event
        end
        it 'renders :show' do
          expect(response).to render_template 'ngos/ongoing_events/show'
        end
      end
      context 'when not owning the event' do
        let(:event) { create :ongoing_event }

        it 'raises ActiveRecord::RecordNotFound' do
          expect{
            get :show, params: { id: event }
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe 'GET new' do
    it_behaves_like :ngos_new
    context 'given a signed in confirmed ngo' do
      let(:ngo) { create :ngo, :confirmed }

      before do
        sign_in ngo, scope: :ngo
        get :new
      end

      it 'renders new' do
        expect(response).to render_template 'ngos/ongoing_events/new'
      end
    end
  end

  describe 'POST create' do
    it_behaves_like :ngos_create
    context 'when signed in as NGO' do
      let(:ngo) { create :ngo, :confirmed }

      before { sign_in ngo, scope: :ngo }

      context 'with invalid params' do
        let(:params) { { ongoing_event: { title: '' } } }
        it 'does not create new event record' do
          expect{
            post :create, params: params
          }.not_to change{ OngoingEvent.count }
        end
        it 'assigns @event' do
          post :create, params: params
          expect(assigns(:event)).to be
        end
        it 'assigns @event the current signed in ngo' do
          post :create, params: params
          expect(assigns(:event).ngo).to eq ngo
        end
        it 'renders :new' do
          post :create, params: params
          expect(response).to render_template :new
        end
      end
      context 'with valid params' do
        let(:ongoing_event_category) { create :ongoing_event_category }
        let(:params) {
          { ongoing_event: {
            title: 'event title',
            description: 'huge event description',
            address: 'street with number',
            contact_person: 'person name',
            volunteers_needed: 1,
            ongoing_event_category_id: ongoing_event_category.id
          } }
        }

        it 'creates new event record' do
          expect{
            post :create, params: params
          }.to change{ OngoingEvent.count }.by 1
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

      before { sign_in ngo, scope: :ngo }

      context 'when owning the event' do
        let(:event) { create :ongoing_event, ngo: ngo }

        before { get :edit, params: { id: event } }

        it 'assigns @event' do
          expect(assigns(:event)).to eq event
        end
        it 'renders :edit' do
          expect(response).to render_template 'ngos/ongoing_events/edit'
        end
      end
      context 'when not owning the event' do
        let(:event) { create :ongoing_event }

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
      let(:params) { { id: event, ongoing_event: { title: 'whatever' } } }

      before { sign_in ngo, scope: :ngo }

      context 'when owning the event' do
        let(:event) { create :ongoing_event, ngo: ngo }

        before do
          put :update, params: params
          event.reload
        end

        it 'assigns @event' do
          expect(assigns(:event)).to eq event
        end
        it 'updates attributes' do
          expect(event).to have_attributes(title: 'whatever')
        end
        it 'redirects to event' do
          expect(response).to redirect_to [:ngos, event]
        end
      end
      context 'when not owning the event' do
        let(:event) { create :ongoing_event }

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
      let!(:event) { create :ongoing_event, ngo: ngo }
      let(:params) { { id: event } }

      before { sign_in ngo, scope: :ngo }

      context 'when owning the event' do
        it 'destroys event' do
          expect{
            delete :destroy, params: params
          }.to change{ OngoingEvent.count }.by -1
        end
        it 'redirects to index' do
          delete :destroy, params: params
          expect(response).to redirect_to ngos_ongoing_events_path
        end
      end
      context 'when not owning the event' do
        let(:event) { create :ongoing_event }

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
      let(:event) { create :ongoing_event, ngo: ngo }
      let(:params) { { id: event } }

      before { sign_in ngo, scope: :ngo }

      context 'when owning the event' do
        it 'updates event state to published' do
          expect{
            post :publish, params: params
            event.reload
          }.to change{ event.state }.to 'published'
        end
        it 'redirects to event' do
          post :publish, params: params
          expect(response).to redirect_to [:ngos, event]
        end
      end
      context 'when not owning the event' do
        let(:event) { create :ongoing_event }

        it 'raises ActiveRecord::RecordNotFound' do
          expect{
            post :publish, params: params
          }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
