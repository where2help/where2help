class AddDeviseTokenAuth < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string, :null => false, :default => "email"
    add_column :users, :uid, :string, :null => false, :default => ""

    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    add_column :users, :name, :string
    add_column :users, :nickname, :string
    add_column :users, :image, :string

    add_column :users, :tokens, :text

    add_index :users, [:uid, :provider],     :unique => true
    add_index :users, :confirmation_token,   :unique => true
  end
end
