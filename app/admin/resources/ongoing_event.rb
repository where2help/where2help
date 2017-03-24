ActiveAdmin.register OngoingEvent do
  include Concerns::Views
  include Concerns::ParanoidScopes
  include Concerns::ParanoidFind

  menu priority: 5
  actions :all, except: [:new, :edit, :update]

  scope :published

  filter :ngo
  filter :title
  filter :address
  filter :ongoing_event_category
  filter :created_at
end
