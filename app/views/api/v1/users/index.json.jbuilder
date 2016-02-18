json.array!(@users) do |user|
  json.extract! user, :id, :first_name
  json.extract! user, :last_name
  json.extract! user, :email
  json.extract! user, :created_at
  json.extract! user, :updated_at
  json.url api_v1_user_url(user, format: :json)
end
