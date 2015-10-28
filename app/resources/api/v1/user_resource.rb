module Api
  module V1
    class UserResource < JSONAPI::Resource
      attributes :email, :first_name, :last_name, :phone, :uid, :name, :nickname

      has_many :volunteerings
      has_many :needs, through: :volunteerings

      def self.records(options = {})
        context = options[:context]

        if context[:current_user].admin?
          User.all
        else
          User.where(id: context[:current_user].id)
        end
      end
    end
  end
end
