module Api
  module V1
    class NeedResource < JSONAPI::Resource
      immutable

      attributes :location, :start_time, :end_time, :volunteers_needed,
                 :city, :category, :user_id, :volunteers_count,
                 :lat, :lng, :description

      def volunteers_count
        @model.volunteers.count
      end
    end
  end
end
