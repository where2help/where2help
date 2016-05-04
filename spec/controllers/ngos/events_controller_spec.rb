require 'rails_helper'

RSpec.describe Ngos::EventsController, type: :controller do

  before do
    @request.env['devise.mapping'] = Devise.mappings[:ngo]
  end

  describe "GET #index" do
    let(:ngo) { create :ngo, :confirmed }
    let(:other_ngo) { create :ngo, :confirmed }
    let(:other_event) { create(:event, ngo: other_ngo) }
    let(:own_events) { create_list(:event, 4, ngo: ngo) }

    context 'given a signed in NGO' do
      before do
        sign_in :ngo, ngo
      end

      it "@events includes the signed in ngo's events" do
        get :index
        expect(assigns(:events)).to match_array(own_events)
      end

      it "@events does not include the other ngo's events" do
        get :index
        expect(assigns(:events)).to_not include(other_event)
      end
    end
  end

  describe "GET #new" do
    context 'given a signed in NGO' do
      before do
        sign_in :ngo, FactoryGirl.create(:ngo, :confirmed)
      end

      it "returns http success" do
        get :new
        expect(response).to have_http_status(:success)
      end
    end

    context 'given a signed in user' do
      before do
        sign_in :user, FactoryGirl.create(:user)
      end

      it "redirects to the NGO sign in page" do
        get :new
        expect(response).to redirect_to(new_ngo_session_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when signed in as user' do
      before { sign_in create(:user) }

      it 'redirects to ngo login with flash' do
        post :create, params: {}
        expect(response).to redirect_to new_ngo_session_path
        expect(flash[:alert]).to be_present
      end
    end
    context 'when signed in as NGO' do
      let(:ngo) { create :ngo, :confirmed }

      before { sign_in ngo }

      context 'with invalid params' do
        let(:params) {{event: {title: ''}}}
        it 'does not create new event record' do
          expect{
            post :create, params: params
          }.not_to change{Event.count}
        end

        it 'assigns @event' do
          post :create, params: params
          expect(assigns :event).to be
        end

        it 'assigns @event the current signed in ngo' do
          post :create, params: params
          expect(assigns(:event).ngo).to eq(ngo)
        end

        it 'renders :new' do
          post :create, params: params
          expect(response).to render_template :new
        end
      end
      context 'with valid params' do
        let(:params) {{ event: {
          title: 'event title',
          description: 'huge event description',
          address: 'street with number',
          shifts_attributes: [ { volunteers_needed: "1",
                                 starts_at: "2016-02-25 17:30:55",
                                 ends_at: "2016-02-25 17:30:55",
                                 volunteers_needed: 1,
                                 volunteers_count: 0 } ] }}}

        it 'creates new event record' do
          expect{
            post :create, params: params
          }.to change{Event.count}.by 1
        end

        it 'redirects to @event' do
          post :create, params: params
          expect(response).to redirect_to [:ngos, assigns(:event)]
        end
      end
    end
  end
end
