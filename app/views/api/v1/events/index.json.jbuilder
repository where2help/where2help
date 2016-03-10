json.array!(@events) do |event|
  json.extract! event, :id, :description, :volunteers_needed, :starts_at, 
                       :ends_at, :shift_length, :address, :lat, :lng, 
                       :state, :created_at. :updated_at

  json.url api_v1_event_url(event, format: :json)

  json.array!(event.shifts) do |shift|
    json.extract! shift, :id, :starts_at, :ends_at, :volunteers_needed, :volunteers_count, 
                         :created_at, :updated_at, :current_user_assigned
  end
end
