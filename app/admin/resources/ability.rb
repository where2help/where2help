ActiveAdmin.register Ability do
  menu priority: 6

  actions :all

  filter :name
  filter :description
  filter :created_at

  form partial: 'form'

  permit_params :name,
                :description
end
