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
          expect(assigns :shift).to eq shift
        end

        it 'renders show' do
          expect(response).to render_template :show
        end
      end
      context 'when pending event' do
        let(:shift) { create :shift, :with_event }

        it 'raises RecordNotFound error' do
          expect{
            get :show, params: { id: shift }
          }.to raise_error ActiveRecord::RecordNotFound
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
          expect{
            post :opt_in, params: { shift_id: shift }
          }.to change{Participation.count}.by 1
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
        before { create :participation, user: user, shift: shift }

        it 'does not create participation record' do
          expect{
            post :opt_in, params: { shift_id: shift }
          }.not_to change{Participation.count}
        end

        it 'assigns @shift' do
          post :opt_in, params: { shift_id: shift }
          expect(assigns :shift).to eq shift
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
          expect{
            delete :opt_out, params: { shift_id: shift }
          }.to change{Participation.count}.by -1
        end

        it 'assigns @shift' do
          delete :opt_out, params: { shift_id: shift }
          expect(assigns :shift).to eq shift
        end

        it 'redirect_to schedule' do
          delete :opt_out, params: { shift_id: shift }
          expect(response).to redirect_to schedule_path
        end
      end
      context 'when not opted in' do

        it 'does not change participation records' do
          expect{
            delete :opt_out, params: { shift_id: shift }
          }.not_to change{Participation.count}
        end

        it 'assigns @shift' do
          delete :opt_out, params: { shift_id: shift }
          expect(assigns :shift).to eq shift
        end

        it 'redirect_to schedule' do
          delete :opt_out, params: { shift_id: shift }
          expect(response).to redirect_to schedule_path
        end
      end
    end
  end
  describe 'GET schedule' do
    context 'when logged out' do
      it 'redirects to user sign_in' do
        get :schedule
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'when logged in' do
      let(:user) { create :user }
      let(:upcoming_shifts) { create_list :shift, 10, :with_event, :skip_validate, starts_at: 1.day.from_now, ends_at: 1.day.from_now+2.hours }
      let(:past_shifts) { create_list :shift, 10, :with_event, :skip_validate, starts_at: 1.day.ago, ends_at: 1.day.ago+2.hours }

      before do
        sign_in user
        upcoming_shifts.each{|s| create :participation, user: user, shift: s}
        past_shifts.each{|s| create :participation, user: user, shift: s}
      end

      context 'when html request' do
        context 'without filter' do
          it 'assigns first 10 shifts' do
            get :schedule
            expect(assigns :collection).to match_array upcoming_shifts
          end
        end
        context 'with :past filter' do
          it 'assigns first 10 past' do
            get :schedule, params: {filter: :past}
            expect(assigns :collection).to match_array past_shifts
          end
        end
        context 'with :all filter' do
          it 'assigns first 10' do
            get :schedule, params: {filter: :all}
            expect(assigns :collection).to match_array past_shifts
          end
        end
      end
      # context 'when js request' do
      #   let(:next_upcoming_shifts) { create_list :shift, 10, :with_event, starts_at: Date.tomorrow+1.day }
      #
      #   before do
      #     next_upcoming_shifts.each{|s| create :participation, user: user, shift: s}
      #   end
      #
      #   context 'without filter' do
      #     it 'assigns next 10 shifts' do
      #       get :schedule, xhr: true, params: { page: 2 }
      #       expect(assigns :shifts).to match_array next_upcoming_shifts
      #     end
      #   end
      #   context 'with :all filter' do
      #     it 'assigns next 10 overall' do
      #       get :schedule, xhr: true, params: { page: 2, filter: :all }
      #       expect(assigns :shifts).to match_array upcoming_shifts
      #     end
      #   end
      # end
    end
  end
end
