namespace :one_offs do
  task :set_default_notification_settings => :environment do
    User.find_each do |user|
      s = User::Settings.new(user)
      s.setup_new_user!
    end
  end
end
