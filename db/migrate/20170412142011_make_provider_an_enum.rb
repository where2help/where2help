class MakeProviderAnEnum < ActiveRecord::Migration[5.0]
  def change
    remove_column :bot_messages, :provider, :string
    add_column    :bot_messages, :provider, :integer
  end
end
