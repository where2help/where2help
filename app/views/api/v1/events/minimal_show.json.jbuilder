# frozen_string_literal: true

json.extract! @event, :id,
              :volunteers_needed
json.shifts @event.shifts do |shift|
  json.extract! shift, :id,
                :volunteers_needed,
                :volunteers_count
  json.current_user_assigned shift.users.include?(current_user)
end
