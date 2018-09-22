# frozen_string_literal: true

class RenameAbilitiesUserToQualification < ActiveRecord::Migration[5.0]
  def change
    rename_table :abilities_users, :qualifications
  end
end
