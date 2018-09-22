# frozen_string_literal: true

class RenameLanguagesUserToSpokenLanguage < ActiveRecord::Migration[5.0]
  def change
    rename_table :languages_users, :spoken_languages
  end
end
