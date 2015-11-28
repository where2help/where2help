module Api
  module V1
    class NeedsController < ApiController
      skip_before_filter :authenticate_user!, only: [:index, :show]
    end
  end
end