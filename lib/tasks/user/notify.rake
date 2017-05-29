namespace :user do
  desc "Find notifiable events and notify users"
  task :notify => :environment do
    User::Notifier::Upcoming.()
  end

  desc "Check if we have bot messages to send out"
  task :unsent_messages => :environment do
    User::Notifier::Unsent.()
  end
end
