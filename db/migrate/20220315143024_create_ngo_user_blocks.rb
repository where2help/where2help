class CreateNgoUserBlocks < ActiveRecord::Migration[5.2]
  def change
    create_table :ngo_user_blocks do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :ngo, foreign_key: true

      t.timestamps
    end
  end
end
