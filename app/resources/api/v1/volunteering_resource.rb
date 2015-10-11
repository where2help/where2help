module Api
  module V1
    class VolunteeringResource < JSONAPI::Resource
      attributes :user_id, :need_id
    end
  end
end
