# frozen_string_literal: true

class AddIndexToUser < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :api_token, unique: true
  end
end
