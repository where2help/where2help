require 'rails_helper'

RSpec.describe "Languages", type: :request do
  describe "GET /languages" do
    it 'returns the languages' do
      language = create :language
      get "/api/v1/languages", as: :json, headers: token_header

      expect(response).to be_successful
      expect(json[0]).to eq({"id" => language.id, "name" => language.name})
    end
  end  
end
