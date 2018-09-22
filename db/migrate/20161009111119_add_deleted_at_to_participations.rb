# frozen_string_literal: true

class AddDeletedAtToParticipations < ActiveRecord::Migration[5.0]
  def change
    add_column :participations, :deleted_at, :datetime
    add_index :participations, :deleted_at
  end
end
