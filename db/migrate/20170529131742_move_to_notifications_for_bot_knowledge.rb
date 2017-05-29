class MoveToNotificationsForBotKnowledge < ActiveRecord::Migration[5.0]
  def change
    remove_index :bot_messages, :sent_at
    remove_index :bot_messages, :last_send_attempt
    remove_column :bot_messages, :sent_at, :datetime, default: nil
    remove_column :bot_messages, :last_send_attempt, :datetime, default: nil
    remove_column :bot_messages, :error_message, :text


    add_column :notifications, :sent_at, :datetime, default: nil
    add_column :notifications, :last_send_attempt, :datetime, default: nil
    add_column :notifications, :error_message, :text
    add_index :notifications, :sent_at
    add_index :notifications, :last_send_attempt
  end
end
