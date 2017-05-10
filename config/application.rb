require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Where2help
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_job.queue_adapter = :sucker_punch

    config.assets.version = '1.2'

    config.i18n.available_locales = [:de, :en]
    config.i18n.default_locale = :de
    config.time_zone = 'Vienna'
    config.autoload_paths += %W["#{config.root}/app/services/"]

    unless Rails.env.test?
      config.after_initialize do
        Rails.application.reload_routes!
        require "chatbot/operation"
        Thread.abort_on_exception = true
        Thread.new do
          ChatbotOperation::Initialize.()
        end
      end
    end
  end
end
