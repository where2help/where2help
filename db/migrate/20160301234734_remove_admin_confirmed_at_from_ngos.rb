# frozen_string_literal: true

class RemoveAdminConfirmedAtFromNgos < ActiveRecord::Migration[5.0]
  def change
    remove_column :ngos, :admin_confirmed_at, :datetime
  end
end
