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
  show { render 'show', context: self }
  form partial: 'form'

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

  permit_params :name,
    :email,
    :identifier,
    :locale,
    :aasm_state,
    contact_attributes: [
      :id,
      :first_name,
      :last_name,
      :email,
      :phone,
      :street,
      :zip,
      :city]
end
