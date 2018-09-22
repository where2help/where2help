# frozen_string_literal: true

class CreateAbilitiesUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :abilities_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :ability, index: true
      t.timestamps
    end
  end
end
