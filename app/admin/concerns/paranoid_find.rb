# frozen_string_literal: true

module Concerns
  module ParanoidFind
    def self.included(base)
      base.send(:controller) do
        def find_resource
          resource_class.unscoped.find(params[:id])
        end
      end
    end
  end
end
