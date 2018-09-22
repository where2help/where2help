# frozen_string_literal: true

class RemoveVolunteersNeededStartsAtAndEndsAtFromEvents < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :starts_at
    remove_column :events, :ends_at
    remove_column :events, :volunteers_needed
  end
end
