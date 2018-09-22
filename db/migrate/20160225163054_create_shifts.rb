# frozen_string_literal: true

class CreateShifts < ActiveRecord::Migration[5.0]
  def change
    create_table :shifts do |t|
      t.belongs_to :event, index: true
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :volunteers_needed
      t.integer :volunteers_count, default: 0

      t.timestamps
    end
  end
end
