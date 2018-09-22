class AddAdminConfirmedAtToNgos < ActiveRecord::Migration[5.0]
  class Ngo < ApplicationRecord
  end

  def up
    add_column :ngos, :admin_confirmed_at, :datetime
    add_index :ngos, :admin_confirmed_at, where: "deleted_at IS NULL"

    Ngo.find_each do |ngo|
      if ngo.aasm_state == 'admin_confirmed'
        ngo.update admin_confirmed_at: ngo.confirmed_at
      end
    end
  end

  def down
    Ngo.find_each do |ngo|
      if ngo.admin_confirmed_at
        ngo.update aasm_state: 'admin_confirmed'
      end
    end

    remove_column :ngos, :admin_confirmed_at
    remove_index :ngos, :admin_confirmed_at
  end
end
