# frozen_string_literal: true

class CreateLanguagesUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :languages_users do |t|
      t.belongs_to :user, index: true
      t.belongs_to :language, index: true
      t.timestamps
    end
  end
end
