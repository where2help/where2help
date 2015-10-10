class ReplaceSkillWithCategoryInNeeds < ActiveRecord::Migration
  def up
    remove_column :needs, :skill
    add_column :needs, :category, :integer
  end

  def down
    remove_column :needs, :category
    add_column :needs, :skill, :string
  end
end
