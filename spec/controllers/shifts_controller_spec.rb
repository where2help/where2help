require 'rails_helper'

RSpec.describe ShiftsController, type: :controller do
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
      let!(:recent_upcoming_shifts) { create_list :shift, 25,
        event: create(:event, :published),
        starts_at: Faker::Date.between(1.day.from_now, 2.days.from_now) }
      let!(:next_upcoming_shifts) { create_list :shift, 25,
        event: create(:event, :published),
        starts_at: Faker::Date.between(3.day.from_now, 5.days.from_now) }
      let(:past_shift) { create :shift,
        event: create(:event, :published), starts_at: Faker::Date.backward(2) }
      let(:full_shift) { create :shift,
        event: create(:event, :published),
        starts_at: Faker::Date.forward(2), volunteers_needed: 2, volunteers_count: 2 }
      let(:shift_unpublished) { create :shift,
        starts_at: Faker::Date.forward(1) }

      before { sign_in create(:user) }

      context 'when html request' do
        before { get :index }

        it 'assigns first 25 upcoming @shifts' do
          expect(assigns :shifts).to match_array recent_upcoming_shifts
        end

        it 'excludes past shifts' do
          expect(assigns :shifts).not_to include past_shift
        end

        it 'excludes full shifts' do
          expect(assigns :shifts).not_to include full_shift
        end

        it 'excludes unpublished shifts' do
          expect(assigns :shifts).not_to include shift_unpublished
        end

        it 'renders index.html' do
          expect(response.content_type).to eq 'text/html'
          expect(response).to render_template :index
        end
      end
      context 'when js request (pagination) with page param' do
        before { get :index, xhr: true, params: { page: 2 } }

        it 'assigns next 25 upcoming shifts' do
          expect(assigns :shifts).to match_array next_upcoming_shifts
        end

        it 'renders index.js' do
          expect(response.content_type).to eq 'text/javascript'
          expect(response).to render_template :index
        end
      end
    end
  end

  describe 'GET show' do
    let(:shift) { create :shift }

    context 'when logged out' do
      it 'redirects to user sign_in' do
        get :show, params: { id: shift }
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in as ngo' do
      before { sign_in create(:ngo, :confirmed) }

      it 'redirects to user sign_in' do
        get :show, params: { id: shift }
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in as user' do
      before do
        sign_in create(:user)
        get :show, params: { id: shift }
      end

      it 'assigns @shift' do
        expect(assigns :shift).to eq shift
      end

      it 'renders :show' do
        expect(response).to render_template :show
      end
    end
  end

  describe 'POST opt_in' do
    let(:shift) { create :shift }

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
        it 'creates shifts_user record' do
          expect{
            post :opt_in, params: { shift_id: shift }
          }.to change{ShiftsUser.count}.by 1
        end

        it 'assigns @shift' do
          post :opt_in, params: { shift_id: shift }
          expect(assigns :shift).to eq shift
        end

        it 'renders :opt_in' do
          post :opt_in, params: { shift_id: shift }
          expect(response).to render_template :opt_in
        end
      end
      context 'when already opted in' do
        before { create :shifts_user, user: user, shift: shift }

        it 'does not create shifts_user record' do
          expect{
            post :opt_in, params: { shift_id: shift }
          }.not_to change{ShiftsUser.count}
        end

        it 'assigns @shift' do
          post :opt_in, params: { shift_id: shift }
          expect(assigns :shift).to eq shift
        end

        it 'redirect_to shift' do
          post :opt_in, params: { shift_id: shift }
          expect(response).to redirect_to shift
        end
      end
    end
  end

  describe 'DELETE opt_out' do
    let(:shift) { create :shift }

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
        before { create :shifts_user, user: user, shift: shift }

        it 'deletes shifts_user record' do
          expect{
            delete :opt_out, params: { shift_id: shift }
          }.to change{ShiftsUser.count}.by -1
        end

        it 'assigns @shift' do
          delete :opt_out, params: { shift_id: shift }
          expect(assigns :shift).to eq shift
        end

        it 'redirect_to shift' do
          delete :opt_out, params: { shift_id: shift }
          expect(response).to redirect_to shift
        end
      end
      context 'when not opted in' do

        it 'does not change shifts_user records' do
          expect{
            delete :opt_out, params: { shift_id: shift }
          }.not_to change{ShiftsUser.count}
        end

        it 'assigns @shift' do
          delete :opt_out, params: { shift_id: shift }
          expect(assigns :shift).to eq shift
        end

        it 'redirect_to shift' do
          delete :opt_out, params: { shift_id: shift }
          expect(response).to redirect_to shift
        end
      end
    end
  end
end
