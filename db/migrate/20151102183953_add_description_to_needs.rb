class AddDescriptionToNeeds < ActiveRecord::Migration
  def change
    add_column :needs, :description, :text
  end
end
