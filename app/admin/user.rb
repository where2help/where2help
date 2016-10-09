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

  controller do
    after_create do
      @user.send_confirmation_instructions
    end
  end
end
