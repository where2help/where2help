# frozen_string_literal: true

class UpdateParticipationsIndices < ActiveRecord::Migration[5.0]
  def up
    remove_index :participations, :shift_id
    remove_index :participations, :user_id
    add_index :participations, :shift_id, where: "deleted_at IS NULL"
    add_index :participations, :user_id, where: "deleted_at IS NULL"
  end

  def down
    remove_index :participations, :shift_id
    remove_index :participations, :user_id
    add_index :participations, :shift_id
    add_index :participations, :user_id
  end
end
