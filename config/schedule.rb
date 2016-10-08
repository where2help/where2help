set :environment, ENV['RAILS_ENV']

every 1.month, at: '4:00 am' do
  rake 'db:cleanup'
end
