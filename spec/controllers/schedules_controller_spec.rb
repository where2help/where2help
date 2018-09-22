require 'rails_helper'

RSpec.describe SchedulesController, type: :controller do
  describe 'GET schedule' do
    context 'when logged out' do
      it 'redirects to user sign_in' do
        get :show
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
            get :show
            actual = (assigns :collection).map(&:object)
            expect(actual).to match_array upcoming_shifts
          end
        end
        context 'with :past filter' do
          it 'assigns first 10 past' do
            get :show, params: {filter: :past}
            actual = (assigns :collection).map(&:object)
            expect(actual).to match_array past_shifts
          end
        end
        context 'with :all filter' do
          it 'assigns first 10' do
            get :show, params: {filter: :all}
            actual = (assigns :collection).map(&:object)
            expect(actual).to match_array (past_shifts + upcoming_shifts)
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
