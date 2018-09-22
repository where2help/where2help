# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.integer :category, default: 0
      t.text :description
      t.integer :volunteers_needed
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :shift_length, default: 2
      t.string :address
      t.float :lat
      t.float :lng
      t.string :state, default: :pending, null: false

      t.timestamps
    end
  end
end
