# frozen_string_literal: true

class AddOngoingEventCategoryToOngoingEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :ongoing_events, :ongoing_event_category, foreign_key: true
  end
end
