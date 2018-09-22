# frozen_string_literal: true

json.array!(@events) do |event|
  json.extract! event, :id,
                :title,
                :description,
                :address,
                :lat,
                :lng,
                :state,
                :person,
                :created_at,
                :updated_at
  json.organization_name event.ngo.name
  json.url api_v1_event_url(event, format: :json)

  json.shifts event.shifts do |shift|
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
end
