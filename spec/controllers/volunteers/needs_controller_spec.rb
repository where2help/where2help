require 'rails_helper'

RSpec.describe Volunteers::NeedsController, type: :controller do

  describe 'GET index' do
    context 'without current_user' do
      context 'when html request' do
        before { get :index }

        it_behaves_like :an_unauthorized_request
      end
    end

    context 'with current_user' do
      let(:user) { create(:user) }
      before { sign_in user }

      context 'when html request' do
        before do
          20.times do
            need = create(:need, start_time: Date.tomorrow)
            create(:volunteering, user: user, need: need)
          end
          get :index
        end

        it 'assigns @needs with users first 10 upcoming appointments' do
          expect(assigns(:needs).to_a).to eq user.appointments.upcoming.first(10)
          expect(assigns(:needs).size).to eq 10
        end

        it 'renders index.html' do
          expect(response['Content-Type']).to eq 'text/html; charset=utf-8'
          expect(response).to render_template(:index)
        end
      end

      context 'when ajax request' do
        context 'with page param' do
          before do
            20.times do
              need = create(:need, start_time: Date.tomorrow)
              create(:volunteering, user: user, need: need)
            end
            xhr :get, :index, page: 2
          end

          it 'assigns @needs with next 10 upcoming @appointments' do
            expect(assigns(:needs)).to eq user.appointments.upcoming.offset(10).first(10)
          end

          it 'renders index.js' do
            expect(response['Content-Type']).to eq 'text/javascript; charset=utf-8'
            expect(response).to render_template(:index)
          end
        end
      end
    end
  end
end
