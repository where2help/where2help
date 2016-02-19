json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :email, :created_at, :updated_at
  json.url api_v1_user_url(user, format: :json)
end
