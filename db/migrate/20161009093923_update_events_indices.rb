# frozen_string_literal: true

class UpdateEventsIndices < ActiveRecord::Migration[5.0]
  def up
    remove_index :events, :ngo_id
    add_index :events, :ngo_id, where: "deleted_at IS NULL"
  end

  def down
    remove_index :events, :ngo_id
    add_index :events, :ngo_id
  end
end
