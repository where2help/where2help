ActiveAdmin.register Ability do
  actions :all

  filter :name
  filter :description
  filter :created_at

  form partial: 'form'

  permit_params :name,
                :description
end
