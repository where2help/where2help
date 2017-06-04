namespace :user do
  desc "Find notifiable events and notify users"
  task :notify => :environment do
    User::Notifier::Upcoming.()
  end

  desc "Send batched unsent notifications via chatbot and email"
  task :send_unsent_notifications => :environment do
    Notification::Batcher.()
  end
end
