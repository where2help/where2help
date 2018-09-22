# frozen_string_literal: true

json.array!(@events) do |event|
  json.extract! event, :id

  json.shifts event.shifts do |shift|
    json.extract! shift, :id,
                  :volunteers_needed,
                  :volunteers_count
    json.current_user_assigned shift.users.include?(current_user)
  end
end
