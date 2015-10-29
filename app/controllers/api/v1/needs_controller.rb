module Api
  module V1
    class NeedsController < ApiController
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
    end
  end
end