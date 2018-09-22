# frozen_string_literal: true

require 'rails_helper'
require 'controllers/shared/ngos_controller'

RSpec.describe Ngos::EventsController, type: :controller do
  describe 'GET index' do
    it_behaves_like :ngos_index

    context 'given a signed in NGO' do
      let(:ngo) { create :ngo, :confirmed }

      before { sign_in ngo, scope: :ngo }

      context 'without events' do
        before { get :index }

        it 'assigns empty @shifts' do
          shifts = assigns :shifts
          expect(shifts.to_a).to be_empty
        end
        it 'renders :index' do
          expect(response).to render_template 'ngos/events/index'
        end
      end
      context 'with events' do
        let!(:own_events) { create_list(:event, 4, :with_shift, ngo: ngo) }

        context 'when no filter parameters given' do
          let(:other_ngo) { create :ngo, :confirmed }
          let!(:other_event) { create(:event, :with_shift, ngo: other_ngo) }

          before { get :index }

          it "@shifts includes the signed in ngo's events" do
            events = (assigns :shifts).map(&:event)
            expect(events).to match_array own_events
          end
          it "@shifts does not include the other ngo's events" do
            expect(assigns(:shifts)).to_not include other_event.shifts.first
          end
          it 'renders :index' do
            expect(response).to render_template 'ngos/events/index'
          end
        end
        context 'with valid filter parameter' do
          let!(:past_event) { create(:event, :with_past_shift, :skip_validate, ngo: ngo) }

          it 'assigns only past events for filter_by :past' do
            get :index, params: { filter_by: 'past' }
            events = (assigns :shifts).map(&:event)
            expect(events).to match_array [past_event]
          end
          it 'assigns only upcoming events for filter_by :upcoming' do
            get :index, params: { filter_by: 'upcoming' }
            events = (assigns :shifts).map(&:event)
            expect(events).to match_array own_events
          end
          it 'assigns all events for filter_by :all' do
            get :index, params: { filter_by: 'all' }
            events = (assigns :shifts).map(&:event)
            expect(events).to match_array (own_events << past_event)
          end
          it 'assigns all events for filter_by nil' do
            get :index, params: { filter_by: '' }
            events = (assigns :shifts).map(&:event)
            expect(events).to match_array (own_events << past_event)
          end
        end
        context 'when invalid filter parameter given' do
          it 'returns all shifts' do
            get :index, params: { filter_by: 'some_random_string' }
            events = (assigns :shifts).map(&:event)
            expect(events).to match_array own_events
          end
        end
        context 'when invalid order parameter given' do
          it 'orders by starts at' do
            get :index, params: { order_by: 'some_random_string' }
            events = (assigns :shifts).map(&:event)
            expect(events).to match_array own_events
          end
        end
        context 'with valid order_by and filter_by parameter' do
          let!(:last_event) { create(:event, :with_shift, :skip_validate, ngo: ngo, title: 'A' * 100) }
          let(:params) { { filter_by: 'upcoming' } }

          before { get :index, params: params }

          it 'returns all filtered events' do
            events = (assigns :shifts).map(&:event)
            expect(events).to match_array (own_events << last_event)
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
        let(:event) { create :event, :with_shift, ngo: ngo }

        before { get :show, params: { id: event } }

        it 'assigns @event' do
          expect(assigns(:event)).to eq event
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

  describe 'GET new' do
    it_behaves_like :ngos_new
    context 'given a signed in confirmed ngo' do
      let(:ngo) { create :ngo, :confirmed }

      before do
        sign_in ngo, scope: :ngo
        get :new
      end

      it 'assigns a new event with one shift' do
        event = assigns :event
        expect(event).to be
        expect(event.shifts.size).to eq 1
      end
      it 'renders new' do
        expect(response).to render_template 'ngos/events/new'
      end
    end
  end

  describe 'POST create' do
    it_behaves_like :ngos_create
    context 'when signed in as NGO' do
      let(:ngo) { create :ngo, :confirmed }

      before { sign_in ngo, scope: :ngo }

      context 'with invalid params' do
        let(:params) { { event: { title: '' } } }
        it 'does not create new event record' do
          expect{
            post :create, params: params
          }.not_to change{ Event.count }
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
        let(:params) {
          {
            event: {
              title: 'event title',
              description: 'huge event description',
              address: 'street with number',
              person: 'person name',
              shifts_attributes: [{
                starts_at: Time.now + 2.hours,
                ends_at: Time.now + 4.hours,
                volunteers_needed: 1,
                volunteers_count: 0
              }]
            }
          }
        }

        it 'creates new event record' do
          expect{
            post :create, params: params
          }.to change{ Event.count }.by 1
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
        let(:event) { create :event, :with_shift, ngo: ngo }

        before { get :edit, params: { id: event } }

        it 'assigns @event' do
          expect(assigns(:event)).to eq event
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
      let(:params) { { id: event, event: { title: 'whatever' } } }

      before { sign_in ngo, scope: :ngo }

      context 'when owning the event' do
        let(:event) { create :event, :with_shift, ngo: ngo }

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
      let(:params) { { id: event } }

      before { sign_in ngo, scope: :ngo }

      context 'when owning the event' do
        let!(:event) { create :event, :with_shift, ngo: ngo }

        it 'destroys event' do
          expect{
            delete :destroy, params: params
          }.to change{ Event.count }.by -1
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
      let(:params) { { id: event } }

      before { sign_in ngo, scope: :ngo }

      context 'when owning the event' do
        let(:event) { create :event, :with_shift, ngo: ngo }

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
