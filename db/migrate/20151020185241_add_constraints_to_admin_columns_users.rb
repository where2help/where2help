class AddConstraintsToAdminColumnsUsers < ActiveRecord::Migration
  def change
    change_column :users, :admin, :boolean, default: false, null: false
    change_column :users, :ngo_admin, :boolean, default: false, null: false
  end
end
