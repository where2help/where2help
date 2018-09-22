class AddTokenToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :api_token, :string
    add_column :users, :api_token_valid_until, :datetime
  end
end
