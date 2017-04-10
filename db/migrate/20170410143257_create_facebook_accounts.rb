class CreateFacebookAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :facebook_accounts do |t|
      t.string :facebook_id
      t.belongs_to :user, foreign_key: true
      t.string :referencing_id

      t.timestamps
    end
    add_index :facebook_accounts, :facebook_id
    add_index :facebook_accounts, :referencing_id
  end
end
