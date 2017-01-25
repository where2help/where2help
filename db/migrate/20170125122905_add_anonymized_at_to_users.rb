class AddAnonymizedAtToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :anonymized_at, :datetime
  end
end
