module Api
  module V1
    class ApiController < JSONAPI::ResourceController
      include DeviseTokenAuth::Concerns::SetUserByToken
      before_filter :authenticate_user!

      def context
        {current_user: current_user}
      end
    end
  end
end