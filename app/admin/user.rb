ActiveAdmin.register User do
  actions :all, except: [:new, :create]
  includes :languages, :abilities

  filter :email
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
    :admin,
    :locale
end
