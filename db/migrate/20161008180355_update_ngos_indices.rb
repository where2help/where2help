class UpdateNgosIndices < ActiveRecord::Migration[5.0]
  def up
    remove_index :ngos, :confirmation_token
    remove_index :ngos, :email
    remove_index :ngos, :reset_password_token

    add_index :ngos, :confirmation_token, where: "deleted_at IS NULL"
    add_index :ngos, :email, where: "deleted_at IS NULL"
    add_index :ngos, :reset_password_token, where: "deleted_at IS NULL"
  end

  def down
    remove_index :ngos, :confirmation_token
    remove_index :ngos, :email
    remove_index :ngos, :reset_password_token

    add_index :ngos, :confirmation_token
    add_index :ngos, :email
    add_index :ngos, :reset_password_token
  end
end
