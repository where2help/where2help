set :environment, ENV['RAILS_ENV']

every 1.month, at: '4:00 am' do
  rake 'db:anonymize_deleted_users'
end

every 1.day, at: '5:00 pm' do
  rake 'user:notify'
end

every 1.day, at: '6:00 pm' do
  rake 'user:send_unsent_notifications'
end

