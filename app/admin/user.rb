ActiveAdmin.register User do
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

  index { render 'index', context: self }
  show { render 'show', context: self }
  form partial: 'form'

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
