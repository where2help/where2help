require 'rails_helper'

RSpec.describe OngoingEventsController, type: :controller do
  describe 'GET index' do
    context 'when logged out' do
      it 'redirects to user sign_in' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in as ngo' do
      before { sign_in create(:ngo, :confirmed) }

      it 'redirects to user sign_in' do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in as user' do
      let(:pending_event) { create :event, :with_shift }
      let!(:categories) { create_list :ongoing_event_category, 5 }
      let!(:nonempty_category) { categories[2] }
      let!(:next_events) { create_list :ongoing_event, 25, :published, ongoing_event_category: nonempty_category }
      let!(:newest_events) { create_list :ongoing_event, 3, :published, ongoing_event_category: nonempty_category }
      let!(:pending_event) { create :ongoing_event }
      before { sign_in create(:user) }

      context 'when html request' do
        before { get :index }

        it 'assigns non-empty categories to @ongoing_event_categories' do
          expect(assigns(:ongoing_event_categories)).to match_array([nonempty_category])
        end

        it 'assigns events for each non-empty category' do
          expect(assigns(:category_events).keys).to match_array([nonempty_category.id])
        end

        it 'assigns first 3 most-recent, published events to @category_events' do
          expect(assigns(:category_events)[nonempty_category.id]).to match_array(newest_events)
        end

        it 'excludes pending events' do
          expect(assigns(:category_events)[nonempty_category.id]).not_to include pending_event
        end

        it 'renders index.html' do
          expect(response.content_type).to eq 'text/html'
          expect(response).to render_template :index
        end
      end
      context 'when js request (pagination) with page param' do
        before { get :index, xhr: true, params: { page: 2, ongoing_event_category_id: categories[2].id } }

        it 'assigns next 25 upcoming shifts' do
          expect(assigns(:events)).to match_array next_events
        end

        it 'renders index.js' do
          expect(response.content_type).to eq 'text/javascript'
          expect(response).to render_template :index
        end
      end
    end
  end
  describe 'GET show' do
    context 'when logged out' do
      it 'redirects to user sign_in' do
        get :show, params: { id: 1 }
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in as ngo' do
      before { sign_in create(:ngo, :confirmed) }

      it 'redirects to user sign_in' do
        get :show, params: { id: 1 }
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in as user' do
      before { sign_in create(:user) }

      context 'when pending event' do
        let(:event) { create :ongoing_event }

        it 'throws record not found error' do
          expect{
            get :show, params: { id: event }
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end
      context 'when published event' do
        let(:event) { create :ongoing_event, :published }

        before { get :show, params: { id: event } }

        it 'assigns @event' do
          expect(assigns(:event)).to eq event
        end
        it 'renders :show' do
          expect(response).to render_template 'ongoing_events/show'
        end
      end
    end
  end

  describe 'POST opt_in' do
    let!(:ongoing_event) { create :ongoing_event, :skip_validate }

    context 'when logged in' do
      let(:user) { create :user }

      before { sign_in user }

      context 'when not opted in yet' do
        it 'sends a notification email to the NGO' do
          message_delivery = instance_double(ActionMailer::MessageDelivery)
          expect(NgoMailer).to receive(:ongoing_event_opt_in).and_return(message_delivery)
          expect(message_delivery).to receive(:deliver_later)

          post :opt_in, params: { id: ongoing_event.id }
        end
      end
    end
  end
end
