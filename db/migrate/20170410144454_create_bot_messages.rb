class CreateBotMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :bot_messages do |t|
      t.string :provider
      t.boolean :from_bot
      t.jsonb :payload
      t.integer :account_id

      t.timestamps
    end
    add_index :bot_messages, :provider
    add_index :bot_messages, :from_bot
    add_index :bot_messages, :account_id
  end
end
