module Api
  module V1
    class NeedsController < JSONAPI::ResourceController
    	before_action :authenticate_user!, except: [:show, :index, :feed]
      def index
        if current_user.admin?
          needs = Need.all
        else
          needs = Need.where(user_id: current_user.id)
        end
        resources = needs.map { |need| NeedResource.new(need, nil) }
        json = JSONAPI::ResourceSerializer.new(NeedResource).serialize_to_hash(resources)
        render json: json
      end

      def create
        sparams = params['data']['attributes']
        start_time = sparams['start-time']
        end_time = sparams['end-time']
        user_id = current_user.id

        need = Need.create!(start_time: start_time, end_time: end_time, user_id: user_id)
        need.save

        need_json = JSONAPI::ResourceSerializer.new(NeedResource).serialize_to_hash(NeedResource.new(need, nil))
        render json: need_json
      end
    end
  end
end
