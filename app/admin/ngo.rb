ActiveAdmin.register Ngo do
  includes :contact

  scope :all, default: true
  scope :pending
  scope :admin_confirmed
  scope :deactivated

  filter :name
  filter :identifier
  filter :email
  filter :confirmed_at
  filter :aasm_state, as: :select, collection: Ngo.aasm.states_for_select
  filter :created_at

  index { render 'index', context: self }
  # show { render 'show', context: self }
  # form partial: 'form'

  batch_action :confirm do |ids|
    batch_action_collection.find(ids).each do |ngo|
      ngo.admin_confirm! if ngo.may_admin_confirm?
    end
    redirect_to collection_path, alert: 'Ausgewählte NGOs wurden bestätigt.'
  end

  batch_action :deactivate do |ids|
    batch_action_collection.find(ids).each do |ngo|
      ngo.deactivate! if ngo.may_deactivate?
    end
    redirect_to collection_path, alert: 'Ausgewählte NGOs wurden deaktiviert.'
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end


end
