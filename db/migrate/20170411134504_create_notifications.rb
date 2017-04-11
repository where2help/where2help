class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.datetime :notified_at
      t.integer :notification_type
      t.string :notifiable_type
      t.integer :notifiable_id
      t.belongs_to :user, foreign_key: true

      t.timestamps
    end
    add_index :notifications, :notified_at
    add_index :notifications, :notification_type
    add_index :notifications, :notifiable_type
    add_index :notifications, :notifiable_id
  end
end
