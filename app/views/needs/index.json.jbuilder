json.array!(@needs) do |need|
  json.extract! need, :id, :location, :start_time, :end_time, :skill, :volunteers_needed
  json.url need_url(need, format: :json)
end
