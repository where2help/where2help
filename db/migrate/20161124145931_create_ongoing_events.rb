class CreateOngoingEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :ongoing_events do |t|
      t.belongs_to :ngo, foreign_key: true
      t.string :title
      t.text :description
      t.string :address
      t.string :approximate_address
      t.string :contact_person
      t.date :start_date
      t.date :end_date
      t.integer :volunteers_count
      t.integer :volunteers_needed
      t.datetime :deleted_at
      t.datetime :published_at
      t.float :lat
      t.float :lng

      t.timestamps
    end
    add_index :ongoing_events, :title
    add_index :ongoing_events, :address
    add_index :ongoing_events, :start_date
    add_index :ongoing_events, :end_date
    add_index :ongoing_events, :lat
    add_index :ongoing_events, :lng
    add_index :ongoing_events, :deleted_at
    add_index :ongoing_events, :published_at
  end
end
