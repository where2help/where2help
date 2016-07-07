require 'rails_helper'

RSpec.describe "Userse", :type => :request do
  describe "POST /login" do
    it 'logs the user in, sets token and returns it, if correct credentials are provided' do
      user = create :user
      post "/api/v1/users/login", params: { email: user.email, 
                                            password: user.password }, 
                                  as: :json

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
      post "/api/v1/users/login", params: { email: user.email, 
                                            password: "wrong" }, 
                                  as: :json

      expect(response).to be_unauthorized
      expect(response.headers["TOKEN"]).to eq nil
      expect(json).to include_json({ logged_in: false })
    end 

    it "doesn't log you in, if you provide a wrong user" do
      user = create :user
      post "/api/v1/users/login", params: { email: "wrong", 
                                            password: user.password }, 
                                  as: :json

      expect(response).to be_unauthorized
      expect(response.headers["TOKEN"]).to eq nil
      expect(json).to include_json({ logged_in: false })
    end 

    it "doesn't log you in, if you haven't confirmed your email address yet" do
      user = create(:user, confirmed_at: nil)
      post "/api/v1/users/login", params: { email: user.email, 
                                            password: user.password }, 
                                  as: :json

      expect(response).to be_unauthorized
      expect(response.headers["TOKEN"]).to eq nil
      expect(json).to include_json({ logged_in: false })
    end 


    describe "GET /users/logout" do
      it "logs you out" do
        get "/api/v1/users/logout", as: :json, headers: token_header    

        expect(response).to be_success
        expect(response.headers["TOKEN"]).to eq nil
        expect(json).to include_json({logged_out: true})
      end
    end


    describe "POST /users/change_password" do
      it "changes password, if you provide the same pass for pass and confirmation" do
        post "/api/v1/users/change_password", params: { password:              "my new pass", 
                                                        password_confirmation: "my new pass" }, 
                                              as: :json, 
                                              headers: token_header
        expect(response).to be_success
        expect(json).to include_json({password_changed: true})
        expect(User.first.valid_password?("my new pass")).to eq true
      end

      it "doesn't change pass, if pass and confirmation don't match" do
        post "/api/v1/users/change_password", params: { password:              "my new pass", 
                                                        password_confirmation: "my new typo!" }, 
                                              as: :json, 
                                              headers: token_header
        expect(response).to have_http_status(406)
        expect(json).to include_json({passwords: "not_matching"})
        expect(User.first.valid_password?("my new pass")).to eq false
        expect(User.first.valid_password?("my new typo!")).to eq false
      end
    end


    describe "POST api/v1/users/update_profile" do
      it "lets you update firstname, lastname, email, locale, but not the password" do
        post "/api/v1/users/update_profile", params: { first_name: "Firstname", 
                                                        last_name: "Lastname",
                                                        email:     "my@email.address",
                                                        locale:    "de",
                                                        password:  "my_password"}, 
                                              as: :json, 
                                              headers: token_header
        expect(response).to be_success
        expect(json).to include_json({profile_updated: true})
        expect(User.first.first_name).to eq "Firstname"
        expect(User.first.last_name).to eq "Lastname"
        expect(User.first.email).to eq "my@email.address"
        expect(User.first.locale).to eq "de"
        expect(User.first.valid_password?("my_secret_password")).to eq true
      end
    end


    describe "POST /api/v1/users/send_reset" do
      it "ends password reset information via email" do
        create(:user, email: "jane@doe.com")
        expect { 
          post "/api/v1/users/send_reset", params: { email: "jane@doe.com" }
        }.to change(Devise.mailer.deliveries, :count).by(1)

        expect(response).to be_success
        expect(json).to include_json({password_reset: "maybe"})
      end
    end


    describe "POST /api/v1/users/resend_confirmation" do
      it "ends password reset information via email" do
        create(:user, email: "jane@doe.com", confirmed_at: nil)
        expect { 
          post "/api/v1/users/resend_confirmation", params: { email: "jane@doe.com" }
        }.to change(Devise.mailer.deliveries, :count).by(1)

        expect(response).to be_success
        expect(json).to include_json({resend_confirmation: "maybe"})
      end
    end
  end
end
