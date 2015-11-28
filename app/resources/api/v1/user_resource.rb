module Api
  module V1
    class UserResource < JSONAPI::Resource
      immutable

      attributes :email, :first_name, :last_name, :phone, :uid, :name, :nickname, :organisation

      has_many :volunteerings
      has_many :needs
      has_many :appointments, through: :volunteerings, source: :need

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
