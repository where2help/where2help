module Api
  module V1
    class UserResource < JSONAPI::Resource
      has_many :volunteerings
      has_many :needs, through: :volunteerings
    end
  end
end
