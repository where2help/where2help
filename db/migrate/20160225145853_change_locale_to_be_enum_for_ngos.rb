class ChangeLocaleToBeEnumForNgos < ActiveRecord::Migration[5.0]
  def up
    remove_column :ngos, :locale
    add_column :ngos, :locale, :integer, default: 0
  end

  def down
    change_column :ngos, :locale, :string
  end
end
