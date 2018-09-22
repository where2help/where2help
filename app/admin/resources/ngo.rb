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

  # hidden in menu, just for direct linking
  scope :by_created_shifts, if: proc { false } do |ngos|
    ngos = ngos.unscoped
      .joins("LEFT JOIN events ON (events.ngo_id = ngos.id)")
      .joins("LEFT JOIN shifts ON (shifts.event_id = events.id)")
      .group("ngos.id")
    if params[:max].present?
      ngos.having(
        "COUNT(ngos.id) >= :min AND COUNT(ngos.id) < :max",
        min: params[:min].to_i,
        max: params[:max].to_i
      )
    else
      ngos.having(
        "COUNT(ngos.id) >= :min",
        min: params[:min].to_i
      )
    end
  end

  batch_action :confirm do |ids|
    batch_action_collection.find(ids).each(&:confirm!)
    redirect_to collection_path, alert: 'Ausgewählte NGOs wurden bestätigt.'
  end

  permit_params :name, :email, :locale,
    contact_attributes: [:id, :first_name, :last_name, :email, :phone,
                         :street, :zip, :city]
end
