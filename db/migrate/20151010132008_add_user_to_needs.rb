class AddUserToNeeds < ActiveRecord::Migration
  def change
    add_column :needs, :user_id, :integer
    add_index :needs, :user_id
  end
end
