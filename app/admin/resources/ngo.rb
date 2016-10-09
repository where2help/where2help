ActiveAdmin.register Ngo do
  include Concerns::Views
  include Concerns::ParanoidScopes
  include Concerns::ParanoidFind
  include Concerns::ErrorsOnDestroy

  menu priority: 2
  actions :all, except: [:new, :create]
  includes :contact

  scope :pending
  scope :confirmed

  filter :name
  filter :email
  filter :confirmed_at
  filter :admin_confirmed_at
  filter :deleted_at
  filter :created_at

  batch_action :confirm do |ids|
    batch_action_collection.find(ids).each { |ngo| ngo.confirm! }
    redirect_to collection_path, alert: 'Ausgewählte NGOs wurden bestätigt.'
  end

  permit_params :name, :email, :locale,
                contact_attributes: [ :id, :first_name, :last_name, :email, :phone,
                                      :street, :zip, :city ]
end
