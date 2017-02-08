set :environment, ENV['RAILS_ENV']

every 1.month, at: '4:00 am' do
  rake 'db:anonymize_deleted_users'
end
