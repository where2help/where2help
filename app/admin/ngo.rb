ActiveAdmin.register Ngo do
  include Concerns::Views
  include Concerns::Scopes

  menu priority: 2
  actions :all, except: [:new, :create]
  includes :contact

  Ngo.aasm.states.map {|s| scope(s.human_name, s.name.to_sym) }

  filter :name
  filter :email
  filter :confirmed_at
  filter :aasm_state, as: :select, collection: Ngo.aasm.states_for_select
  filter :created_at

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

  permit_params :name, :email, :locale, :aasm_state,
                contact_attributes: [ :id, :first_name, :last_name, :email, :phone,
                                      :street, :zip, :city ]

  controller do
    before_update do
      if @ngo.aasm_state == "admin_confirmed" && @ngo.changed_attributes[:aasm_state] == "pending"
        NgoMailer.admin_confirmed(@ngo).deliver_later
      end
    end
  end
end
