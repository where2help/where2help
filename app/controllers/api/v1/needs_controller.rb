module Api
  module V1
    class NeedsController < JSONAPI::ResourceController
    	before_action :authenticate_via_email
    end
  end
end