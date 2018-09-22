# frozen_string_literal: true

class AddOngoingEventToParticipations < ActiveRecord::Migration[5.0]
  def change
    add_column :participations, :ongoing_event_id, :integer
    add_index :participations, :ongoing_event_id
  end
end
