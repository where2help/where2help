class AddLatAndLngToNeeds < ActiveRecord::Migration
  def change
    add_column :needs, :lat, :decimal
    add_column :needs, :lng, :decimal
  end
end
