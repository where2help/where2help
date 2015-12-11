class LatLngToFloat < ActiveRecord::Migration
  def change
    change_column :needs, :lat, :float
    change_column :needs, :lng, :float
  end
end
