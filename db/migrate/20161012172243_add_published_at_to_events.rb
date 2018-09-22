# frozen_string_literal: true

class AddPublishedAtToEvents < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :published_at, :datetime
    add_index :events, :published_at, where: "deleted_at IS NULL"
  end
end
