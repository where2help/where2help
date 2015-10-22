module Api
  module V1
    class NeedsController < JSONAPI::ResourceController
      include DeviseTokenAuth::Concerns::SetUserByToken
      before_filter :authenticate_user!

      def create
        sparams    = params['data']['attributes']
        start_time = sparams['start-time']
        end_time   = sparams['end-time']
        need       = current_user.needs.create!(start_time: start_time, end_time: end_time)
        need_json  = JSONAPI::ResourceSerializer.new(NeedResource).serialize_to_hash(NeedResource.new(need, nil))
        render json: need_json
      end

      def update
        super
        ::NotifyJob.new.perform("notify!!!!!!!!!!!")
        Rails.logger.debug '=========================lslslalfas'
      end

      def index
        super
        puts "======================================="
        puts "Access-Token: " + request.headers["Access-Token"]
        puts "Token-Type: " + request.headers["Token-Type"]
        puts "Client: " + request.headers["Client"]
        puts "Uid: " + request.headers["Uid"]
        puts "======================================="
      end
    end
  end
end

