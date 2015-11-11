require 'rails_helper'

RSpec.describe NeedsController, type: :controller do

  describe 'GET index' do
    context 'without current_user' do
      context 'when html request' do
        before do
          20.times{create(:need, start_time: Date.tomorrow)}
          get :index
        end

        it 'assigns first 10 @needs' do
          expect(assigns(:needs).size).to eq 10
        end

        it 'renders list.html' do
          expect(response['Content-Type']).to eq 'text/html; charset=utf-8'
          expect(response).to render_template(:index)
        end
      end
    end

    context 'with current_user' do
      before { sign_in create(:user) }

      context 'when html request' do
        before do
          20.times{create(:need, start_time: Date.tomorrow)}
          get :index
        end

        it 'assigns first 10 @needs' do
          expect(assigns(:needs).size).to eq 10
        end

        it 'renders list.html' do
          expect(response['Content-Type']).to eq 'text/html; charset=utf-8'
          expect(response).to render_template(:index)
        end
      end

      context 'when ajax request' do
        context 'with page param' do
          before do
            20.times{create(:need, start_time: Date.tomorrow)}
            xhr :get, :index, page: 2
          end

          it 'assigns next 10 upcoming @needs' do
            expect(assigns(:needs)).to eq Need.upcoming.offset(10).first(10)
          end

          it 'renders list.js' do
            expect(response['Content-Type']).to eq 'text/javascript; charset=utf-8'
            expect(response).to render_template(:index)
          end
        end
      end
    end
  end
end
