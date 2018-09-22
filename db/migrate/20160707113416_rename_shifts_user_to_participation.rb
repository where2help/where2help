# frozen_string_literal: true

class RenameShiftsUserToParticipation < ActiveRecord::Migration[5.0]
  def change
    rename_table :shifts_users, :participations
  end
end
