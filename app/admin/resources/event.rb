# frozen_string_literal: true

ActiveAdmin.register Event do
  include Concerns::Views
  include Concerns::ParanoidScopes
  include Concerns::ParanoidFind

  menu priority: 4
  actions :all, except: %i[new edit update]
  includes :shifts

  scope :pending
  scope :published

  filter :ngo
  filter :title
  filter :address
  filter :created_at
end
