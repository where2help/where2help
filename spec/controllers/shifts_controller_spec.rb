require 'rails_helper'

RSpec.describe ShiftsController, type: :controller do
  describe 'GET show' do
    context 'when logged out' do
      it 'redirects to user sign_in' do
        get :show, params: { id: 1 }
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in' do
      before { sign_in create(:user) }

      context 'when published event' do
        let(:shift) { create :shift, event: create(:event, :published, :with_shift) }

        before { get :show, params: { id: shift } }

        it 'assigns @shift' do
          expect(assigns(:shift)).to eq shift
        end

        it 'renders show' do
          expect(response).to render_template :show
        end
      end
      context 'when pending event' do
        let(:shift) { create :shift, :with_event }

        it 'raises RecordNotFound error' do
          expect do
            get :show, params: { id: shift }
          end.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
  describe 'POST opt_in' do
    let!(:event) { create :event, :skip_validate }
    let!(:shift) { create :shift, event: event }

    # before do
    #   event.save
    #   shift.save
    # end

    context 'when logged out' do
      it 'redirects to user sign_in' do
        post :opt_in, params: { shift_id: shift }
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in' do
      let(:user) { create :user }

      before { sign_in user }

      context 'when not opted in yet' do
        it 'creates participation record' do
          expect do
            post :opt_in, params: { shift_id: shift }
          end.to change { Participation.count }.by 1
        end

        it 'assigns @shift' do
          post :opt_in, params: { shift_id: shift }
          expect(assigns(:shift)).to eq shift
        end

        it 'renders :opt_in' do
          post :opt_in, params: { shift_id: shift }
          expect(response).to render_template :opt_in
        end

        it 'does not send any emails' do
          expect do
            post :opt_in, params: { shift_id: shift }
          end.to_not change { ActionMailer::Base.deliveries.count }
        end
      end
      context 'when already opted in' do
        before { create :participation, user: user, shift: shift }

        it 'does not create participation record' do
          expect do
            post :opt_in, params: { shift_id: shift }
          end.not_to change { Participation.count }
        end

        it 'assigns @shift' do
          post :opt_in, params: { shift_id: shift }
          expect(assigns(:shift)).to eq shift
        end

        it 'redirect_to event' do
          post :opt_in, params: { shift_id: shift }
          expect(response).to redirect_to event
        end
      end
    end
  end

  describe 'DELETE opt_out' do
    let(:shift) { create :shift, :with_event }

    context 'when logged out' do
      it 'redirects to user sign_in' do
        delete :opt_out, params: { shift_id: shift }
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in' do
      let(:user) { create :user }

      before { sign_in user }

      context 'when opted in yet' do
        before { create :participation, user: user, shift: shift }

        it 'deletes participation record' do
          expect do
            delete :opt_out, params: { shift_id: shift }
          end.to change { Participation.count }.by -1
        end

        it 'assigns @shift' do
          delete :opt_out, params: { shift_id: shift }
          expect(assigns(:shift)).to eq shift
        end

        it 'redirect_to schedule' do
          delete :opt_out, params: { shift_id: shift }
          expect(response).to redirect_to schedule_path
        end
      end
      context 'when not opted in' do
        it 'does not change participation records' do
          expect do
            delete :opt_out, params: { shift_id: shift }
          end.not_to change { Participation.count }
        end

        it 'assigns @shift' do
          delete :opt_out, params: { shift_id: shift }
          expect(assigns(:shift)).to eq shift
        end

        it 'redirect_to schedule' do
          delete :opt_out, params: { shift_id: shift }
          expect(response).to redirect_to schedule_path
        end
      end
    end
  end
end
