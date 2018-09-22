# frozen_string_literal: true

context.instance_eval do
  attributes_table do
    row :id
    row :name
    row :description
    row :created_at
  end
end
