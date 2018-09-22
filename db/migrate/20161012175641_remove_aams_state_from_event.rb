# frozen_string_literal: true

class RemoveAamsStateFromEvent < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :state, :string
  end
end
