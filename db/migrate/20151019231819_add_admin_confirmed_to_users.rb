class AddAdminConfirmedToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin_confirmed, :boolean, null: false, default: true
  end
end
