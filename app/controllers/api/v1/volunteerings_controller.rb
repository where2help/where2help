module Api
  module V1
    class VolunteeringsController < ApiController

      def create
      	sparams = params['data']['attributes']
        user = User.find_by(email: params['email'])

        unless user
          user = User.new(email: params['email'])
          user.save(validate: false)
        end

        volunteering = Volunteering.create(user_id: user.id, need_id: sparams['need_id'])

        volunteering_json = JSONAPI::ResourceSerializer.new(VolunteeringResource).serialize_to_hash(VolunteeringResource.new(volunteering, nil))
        render json: volunteering_json
      end
    end
  end
end