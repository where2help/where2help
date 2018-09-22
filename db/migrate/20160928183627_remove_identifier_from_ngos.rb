# frozen_string_literal: true

class RemoveIdentifierFromNgos < ActiveRecord::Migration[5.0]
  def change
    remove_column :ngos, :identifier
  end
end
