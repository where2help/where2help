# frozen_string_literal: true

context.instance_eval do
  selectable_column
  id_column
  column :name_en
  column :name_de
  column :created_at
  actions
end
