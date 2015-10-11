module Api
  module V1
    class NeedsController < JSONAPI::ResourceController
    	before_action :authenticate_user!
    end
  end
end