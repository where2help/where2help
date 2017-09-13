set :environment, ENV['RAILS_ENV']

every 1.month, at: '4:00 am' do
  rake 'db:anonymize_deleted_users'
end

every 1.day, at: '2:00 pm' do
  rake 'mailer:check_for_expiring_ongoing_events'
end

every 1.day, at: '1:00 pm' do
  rake 'ongoing_events:unpublished_unrenewed'
end
