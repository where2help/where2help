# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
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
      let(:past_event) { create :event, :with_past_shift, :skip_validate }
      let(:full_event) { create :event, :with_full_shift }
      let!(:events) { create_list :event, 25, :published, :with_shift }
      let!(:next_events) { create_list :event, 25, :published, :with_shift }
      before { sign_in create(:user) }

      context 'when html request' do
        before { get :index }

        it 'assigns first 25 published events with available shifts to @events' do
          expect(assigns(:events)).to match_array events
        end

        it 'excludes pending events' do
          expect(assigns(:events)).not_to include pending_event
        end

        it 'excludes events with only past shifts' do
          expect(assigns(:events)).not_to include past_event
        end

        it 'excludes events with only full shifts' do
          expect(assigns(:events)).not_to include full_event
        end

        it 'renders index.html' do
          expect(response.content_type).to eq 'text/html'
          expect(response).to render_template :index
        end
      end
      context 'when js request (pagination) with page param' do
        before { get :index, xhr: true, params: { page: 2 } }

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
        let(:event) { create :event, :with_shift }

        it 'throws record not found error' do
          expect{
            get :show, params: { id: event }
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end
      context 'when published event' do
        let(:event) { create :event, :published, :with_shift }

        before { get :show, params: { id: event } }

        it 'assigns @event' do
          expect(assigns(:event)).to eq event
        end
        it 'renders :show' do
          expect(response).to render_template 'events/show'
        end
      end
    end
  end
end
