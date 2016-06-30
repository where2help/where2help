require 'rails_helper'

RSpec.describe "Registrations", :type => :request do
  describe "GET /authors/:id" do
    it 'creates a new user for proper attributes' do
      user = { first_name: "Jane", last_name: "Doe", email: "jane@doe.com",
               phone: "1234567890", password: "supersecret", password_confirmation: "supersecret" }
               
      post "/api/v1/users/register", user, { "ACCEPT" => "application/json" }
      
      expect(response).to be_success
      expect(json).to include_json user.except(:password, :password_confirmation)
    end
  end
end