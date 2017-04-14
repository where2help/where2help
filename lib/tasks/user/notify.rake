namespace :user do
  desc "Find notifiable events and notify users"
  task :notify => :environment do
    User::Notifier::Upcoming.()
  end
end
