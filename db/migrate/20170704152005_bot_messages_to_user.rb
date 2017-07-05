class BotMessagesToUser < ActiveRecord::Migration[5.0]
  def change
    remove_column :bot_messages, :account_id, :integer
    add_column :bot_messages, :user_id, :integer
    add_foreign_key :bot_messages, :users
    add_index :bot_messages, :user_id
  end
end
