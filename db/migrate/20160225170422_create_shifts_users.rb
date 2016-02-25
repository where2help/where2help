class CreateShiftsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :shifts_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :shift, index: true
      t.timestamps
    end
  end
end
