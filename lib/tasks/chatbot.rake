namespace :chatbot do
  desc "Initialize Messenger persistent menu and get started"
  task :init => :environment do
    require "chatbot/operation"
    Rails.application.reload_routes!
    msg = "Initializing chatbot 'Get Started' and Persistent Menu"
    Rails.logger.info(msg)
    STDERR.puts(msg)
    ChatbotOperation::Initialize.()
  end
end
