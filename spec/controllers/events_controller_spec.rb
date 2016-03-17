require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  before do
    @request.env['devise.mapping'] = Devise.mappings[:ngo]
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
end
