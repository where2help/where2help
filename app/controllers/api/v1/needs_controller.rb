module Api
  module V1
    class NeedsController < JSONAPI::ResourceController
      include DeviseTokenAuth::Concerns::SetUserByToken

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

      def update
        super
        ::NotifyJob.new.perform("notify!!!!!!!!!!!")
        Rails.logger.debug '=========================lslslalfas'
      end
    end
  end
end
