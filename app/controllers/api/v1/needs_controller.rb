module Api
  module V1
    class NeedsController < JSONAPI::ResourceController
    	before_action :authenticate_user!, except: [:show, :index, :feed]
    end
  end
end