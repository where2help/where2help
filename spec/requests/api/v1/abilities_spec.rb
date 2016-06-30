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
end
