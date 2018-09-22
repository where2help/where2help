class MakeAdminFalseByDefaultForUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :admin, :boolean, default: false
  end
end
