# frozen_string_literal: true

class ChangeLocaleToBeEnum < ActiveRecord::Migration[5.0]
  def up
    remove_column :users, :locale
    add_column :users, :locale, :integer, default: 0
  end

  def down
    change_column :users, :locale, :string
  end
end
