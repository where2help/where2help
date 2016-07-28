require 'rails_helper'

RSpec.describe "Abilities", :type => :request do
  describe "GET /abilities" do
    it 'returns the abilities' do
      ability = create :ability
      get "/api/v1/abilities", as: :json, headers: token_header

      expect(response).to be_success
      expect(json[0]).to eq({"id" => ability.id, "name" => ability.name, "description" => ability.description})
    end
  end
  
  describe "all api controllers" do
    it "should have set and returned the token" do
      get "/api/v1/abilities", as: :json, headers: token_header

      user = User.first
      expect(user.api_token.length).to eq 24
      expect(user.api_token_valid_until).to be > (Time.now + 1.day) 
      expect(response.headers["TOKEN"].length).to eq 24
    end
    
    it "should enforce login (token)" do
      get "/api/v1/abilities", as: :json
      expect(response).not_to be_success
    end
  end
end
