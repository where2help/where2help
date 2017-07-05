class MoveUserSettingsAndFbToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :allow_facebook_notifications, :boolean, default: false
    add_column :users, :allow_email_notifications, :boolean, default: true
    add_column :users, :notify_new_events, :boolean, default: true
    add_column :users, :notify_upcoming_events, :boolean, default: true
    add_column :users, :notify_updated_events, :boolean, default: true

    add_column :users, :facebook_id, :string
    add_column :users, :facebook_reference_id, :string

    add_index :users, :facebook_id
    add_index :users, :facebook_reference_id

    remove_column :users, :settings, "jsonb"

    drop_table :facebook_accounts
  end
end
