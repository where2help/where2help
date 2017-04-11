namespace :user do
  desc "Find notifiable events and notify users"
  task :notify => :environment do
    notifier = User::Notifier.new
    notifier.notify_upcoming!
  end
end
