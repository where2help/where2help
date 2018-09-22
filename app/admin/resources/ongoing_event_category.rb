ActiveAdmin.register OngoingEventCategory do |config|
  menu priority: 8
  actions :all

  filter :name_en
  filter :name_de
  filter :created_at

  form partial: 'form'

  permit_params :name_en, :name_de
end
