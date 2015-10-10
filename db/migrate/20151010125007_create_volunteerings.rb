class CreateVolunteerings < ActiveRecord::Migration
  def change
    create_table :volunteerings do |t|
      t.belongs_to :user, index: true
      t.belongs_to :need, index: true

      t.timestamps null: false
    end
  end
end
