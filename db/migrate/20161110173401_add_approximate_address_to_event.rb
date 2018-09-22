# frozen_string_literal: true

class AddApproximateAddressToEvent < ActiveRecord::Migration[5.0]
  def change
    add_column :events, :approximate_address, :string
  end
end
