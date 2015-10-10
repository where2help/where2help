module Api
  module V1
    class NeedResource < JSONAPI::Resource
      attributes :location, :start_time, :end_time, :volunteers_needed, :city, :category
      has_many :volunteerings
      has_many :users, through: :volunteerings
    end
  end
end
