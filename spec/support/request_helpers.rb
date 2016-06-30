module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end

    def valid_token
      user = create :user
      post "/api/v1/users/login", params: {email: user.email, password: user.password}, as: :json
      response.headers["TOKEN"]
    end

    def token_header
      {"Authorization": "Token token=" + valid_token}
    end
  end
end