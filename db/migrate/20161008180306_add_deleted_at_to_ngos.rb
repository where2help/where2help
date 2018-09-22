# frozen_string_literal: true

class AddDeletedAtToNgos < ActiveRecord::Migration[5.0]
  def change
    add_column :ngos, :deleted_at, :datetime
    add_index :ngos, :deleted_at
  end
end
