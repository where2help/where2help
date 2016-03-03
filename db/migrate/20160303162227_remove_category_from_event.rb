class RemoveCategoryFromEvent < ActiveRecord::Migration[5.0]
  def change
    remove_column :events, :category
  end
end
