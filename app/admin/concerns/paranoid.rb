module Concerns
  module Paranoid
    def self.included(base)
      base.send(:scope, :without_deleted, default: true)
      base.send(:scope, :only_deleted)
      base.send(:controller) do
        def find_resource
          resource_class.unscoped.find(params[:id])
        end
      end
    end
  end
end
