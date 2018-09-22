# frozen_string_literal: true

class CreateOngoingEventCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :ongoing_event_categories do |t|
      t.string :name_en
      t.string :name_de
      t.integer :ordinal

      t.timestamps
    end
  end
end
