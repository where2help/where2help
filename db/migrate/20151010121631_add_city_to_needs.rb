class AddCityToNeeds < ActiveRecord::Migration
  def up
    add_column :needs, :city, :string
  end
  def down
    remove_column :needs, :city, :string
  end
end
