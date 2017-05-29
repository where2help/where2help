class AddSentAtToBotMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :bot_messages, :sent_at, :datetime, default: nil
    add_column :bot_messages, :last_send_attempt, :datetime, default: nil
    add_column :bot_messages, :error_message, :text
    add_index :bot_messages, :sent_at
    add_index :bot_messages, :last_send_attempt
  end
end
