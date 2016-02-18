json.array!(@users) do |user|
  json.extract! user, :id
  json.url api_v1_user_url(user, format: :json)
end
