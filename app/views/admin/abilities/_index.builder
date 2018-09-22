# frozen_string_literal: true

context.instance_eval do
  selectable_column
  id_column
  column :name
  column :description
  column :created_at
  actions
end
