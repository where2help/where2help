module Api
  module V1
    class NeedResource < JSONAPI::Resource
      attributes :location, :start_time, :end_time, :volunteers_needed, :city, :category, :user_id, :volunteers_count

      def volunteers_count
        "#{@model.volunteers.count}"
      end
    end
  end
end
