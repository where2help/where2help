require 'rails_helper'

RSpec.describe VolunteeringsController, type: :controller do
  # Create first admin user
  before { create(:admin) }

  describe 'POST create' do
    let!(:need) { create(:need) }

    context 'when js request' do
      context 'when signed in' do
        let(:user) { create(:user) }
        before { sign_in user }

        it 'creates new volunteerings record' do
          expect{
            xhr :post, :create, need_id: need
          }.to change(Volunteering, :count).by 1
        end

        it 'renders create.js' do
          xhr :post, :create, need_id: need
          expect(response['Content-Type']).to include 'text/javascript;'
          expect(response).to render_template :create
        end

        describe 'volunteering' do
          before { xhr :post, :create, need_id: need }
          subject(:volunteering) { Volunteering.last }

          it 'has current_user' do
            expect(volunteering.user).to eq user
          end
        end
      end

      context 'when not signed in' do
        before { xhr :post, :create, need_id: need }

        it 'does not create new volunteerings record' do
          expect{
            xhr :post, :create, need_id: need
          }.not_to change{Volunteering.count}
        end

        it 'returns 401' do
          xhr :post, :create, need_id: need
          expect(response.status).to eq 401
        end
      end
    end
  end
end
