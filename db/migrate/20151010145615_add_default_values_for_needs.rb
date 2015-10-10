class AddDefaultValuesForNeeds < ActiveRecord::Migration
  def change
    change_column :needs, :volunteers_needed, :integer, default: 1, null: false
    change_column :needs, :category, :integer, default: 0, null: false
  end
end