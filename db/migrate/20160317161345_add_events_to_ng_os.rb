# frozen_string_literal: true

class AddEventsToNgOs < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :ngo, index: true, foreign_key: true
  end
end
