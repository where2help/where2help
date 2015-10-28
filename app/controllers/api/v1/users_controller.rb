module Api
  module V1
    class UsersController < JSONAPI::ResourceController
      include DeviseTokenAuth::Concerns::SetUserByToken
      before_filter :authenticate_user!

      def context
        {current_user: current_user}
      end

      def create
        # nope, we don't create users here
      end

      def destroy
        # nope, we don't destroy users here
      end
    end
  end
end