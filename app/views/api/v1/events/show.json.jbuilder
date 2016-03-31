json.extract! @event, :id,
                      :title,
                      :description,
                      :shift_length,
                      :address,
                      :lat,
                      :lng,
                      :state,
                      :created_at,
                      :updated_at
json.organization_name @event.ngo.name


json.shifts @event.shifts do |shift|
  json.extract! shift, :id,
                      :event_id,
                      :starts_at,
                      :ends_at,
                      :volunteers_needed,
                      :volunteers_count,
                      :created_at,
                      :updated_at
  json.current_user_assigned shift.users.include?(current_user)
end
