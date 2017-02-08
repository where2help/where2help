ActiveAdmin.register Language do
  menu priority: 7
  actions :all

  filter :name
  filter :created_at

  form partial: 'form'

  permit_params :name
end
