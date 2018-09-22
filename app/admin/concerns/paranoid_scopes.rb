# frozen_string_literal: true

module Concerns
  module ParanoidScopes
    def self.included(base)
      base.send(:scope, :without_deleted, default: true)
      base.send(:scope, :only_deleted)
    end
  end
end
