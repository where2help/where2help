ActiveAdmin.register Language do
  actions :all

  filter :name
  filter :created_at

  form partial: 'form'

  permit_params :name
end
