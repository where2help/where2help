class AddTokenToOngoingEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :ongoing_events, :token, :string
    add_index :ongoing_events, :token, unique: true
  end
end
