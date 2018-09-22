# frozen_string_literal: true

class UpdateShiftsIndices < ActiveRecord::Migration[5.0]
  def up
    remove_index :shifts, :event_id
    add_index :shifts, :event_id, where: "deleted_at IS NULL"
  end

  def down
    remove_index :shifts, :event_id
    add_index :shifts, :event_id
  end
end
