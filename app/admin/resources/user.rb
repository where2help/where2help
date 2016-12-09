ActiveAdmin.register User do
  include Concerns::Views
  include Concerns::ParanoidScopes
  include Concerns::ParanoidFind

  menu priority: 3
  actions :all
  includes :languages, :abilities

  filter :email
  filter :phone
  filter :first_name
  filter :last_name
  filter :admin
  filter :languages
  filter :abilities
  filter :created_at

  permit_params :email,
    :first_name,
    :last_name,
    :phone,
    :admin,
    :locale,
    ability_ids: [],
    language_ids: []

  member_action :lock, method: :put do
    UserOperation::Lock.(user: resource)
    redirect_to resource_path, notice: t(".successful")
  end

  member_action :unlock, method: :put do
    UserOperation::Unlock.(user: resource)
    redirect_to resource_path, notice: t(".successful")
  end

  action_item :lock, only: :show do
    if resource.locked?
      link_to t(".user.unlock"), unlock_admin_user_path(resource), method: :put
    else
      link_to t(".user.lock"),   lock_admin_user_path(resource),   method: :put
    end
  end

  controller do
    after_create do
      @user.send_confirmation_instructions
    end
  end
end
