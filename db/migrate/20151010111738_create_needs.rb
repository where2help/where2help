class CreateNeeds < ActiveRecord::Migration
  def change
    create_table :needs do |t|
      t.string :location
      t.datetime :start_time
      t.datetime :end_time
      t.string :skill
      t.integer :volunteers_needed

      t.timestamps null: false
    end
  end
end
