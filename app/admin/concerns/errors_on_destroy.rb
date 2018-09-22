module Concerns
  module ErrorsOnDestroy
    def self.included(base)
      base.send(:after_destroy, :check_model_errors)
      base.send(:controller) do
        def check_model_errors(object)
          return unless object.errors.any?

          flash[:error] ||= []
          flash[:error].concat(object.errors.full_messages)
        end
      end
    end
  end
end
