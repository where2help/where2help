require 'rails_helper'

RSpec.describe "Registrations", type: :request do
  describe "POST /users/register" do
    it 'creates a new user for proper attributes' do
      user = { first_name: "Jane", last_name: "Doe", email: "jane@doe.com",
               phone: "1234567890", password: "supersecret", password_confirmation: "supersecret" }

      post "/api/v1/users/register", params: user, as: :json

      expect(response).to be_successful
      expect(json).to include_json user.except(:password, :password_confirmation)
    end

    it 'fails to create user if email missing' do
      user = { first_name: "Jane", last_name: "Doe", phone: "1234567890" }

      post "/api/v1/users/register", params: user, as: :json

      expect(response).to have_http_status(400)
      expect(json).to include_json( email: ["muss ausgefüllt werden"],
                                    password: ["muss ausgefüllt werden"] )
    end
  end
end
