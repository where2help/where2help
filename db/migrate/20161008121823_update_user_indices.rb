# frozen_string_literal: true

class UpdateUserIndices < ActiveRecord::Migration[5.0]
  def up
    remove_index :users, :api_token
    remove_index :users, :confirmation_token
    remove_index :users, :email
    remove_index :users, :reset_password_token

    add_index :users, :api_token, where: "deleted_at IS NULL"
    add_index :users, :confirmation_token, where: "deleted_at IS NULL"
    add_index :users, :email, where: "deleted_at IS NULL"
    add_index :users, :reset_password_token, where: "deleted_at IS NULL"
  end

  def down
    remove_index :users, :api_token
    remove_index :users, :confirmation_token
    remove_index :users, :email
    remove_index :users, :reset_password_token

    add_index :users, :api_token
    add_index :users, :confirmation_token
    add_index :users, :email
    add_index :users, :reset_password_token
  end
end
