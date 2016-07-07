require 'rails_helper'

RSpec.describe "Userse", :type => :request do
  describe "POST /login" do
    it 'logs the user in, sets token and returns it, if correct credentials are provided' do
      user = create :user
      post "/api/v1/users/login", params: {email: user.email, password: user.password}, as: :json

      user.reload
      expect(user.api_token.length).to eq 24
      expect(user.api_token_valid_until).to be > (Time.now + 1.day) 

      expect(response).to be_success
      expect(response.headers["TOKEN"].length).to eq 24
      expect(json).to include_json({ first_name: user.first_name, 
                                     last_name:  user.last_name,
                                     email:      user.email })
    end

    it "doesn't log you in, if you provide a wrong password" do
      user = create :user
      post "/api/v1/users/login", params: {email: user.email, password: "wrong"}, as: :json

      expect(response).to be_unauthorized
      expect(response.headers["TOKEN"]).to eq nil
      expect(json).to include_json({ logged_in: false })
    end 

    it "doesn't log you in, if you provide a wrong user" do
      user = create :user
      post "/api/v1/users/login", params: {email: "wrong", password: user.password}, as: :json

      expect(response).to be_unauthorized
      expect(response.headers["TOKEN"]).to eq nil
      expect(json).to include_json({ logged_in: false })
    end 

    it "doesn't log you in, if you haven't confirmed your email address yet" do
      user = create(:user, confirmed_at: nil)
      post "/api/v1/users/login", params: {email: user.email, password: user.password}, as: :json

      expect(response).to be_unauthorized
      expect(response.headers["TOKEN"]).to eq nil
      expect(json).to include_json({ logged_in: false })
    end 
  end
end
