module Chatbot
  class Brain
    attr_reader :fbid

    def initialize(msg)
      Rails.logger.debug("Chatbot::Brain received: #{msg.inspect}")
      @msg  = msg
      @fbid = msg.sender.id
    end

    def hear
      case @msg
      when MessengerClient::Message::Optin    then handle_optin
      when MessengerClient::Message::Text     then handle_text_message
      when MessengerClient::Message::Postback then handle_postback
      else
        Rails.logger.warn "Chatbot::Brain#hear doesn't know how to handle: #{@msg.inspect}"
        random_message("chatbot.responses.dont_understand")
        send_messages("chatbot.responses.help", help_url: help_url)
      end
    end

    ##########################
    # Handlers
    ##########################

    def handle_text_message
      return handle_unregistered_user if user.nil?
      case @msg.text
      when list_matcher("chatbot.user.help", locale)
        send_messages("chatbot.responses.help", help_url: help_url)
      when list_matcher("chatbot.user.hello", locale)
        random_message("chatbot.responses.hello")
      else
        random_message("chatbot.responses.dont_understand")
      end
    end

    def handle_postback
      return handle_unregistered_user if user.nil?
      case @msg.postback.to_s
      when Postbacks::GET_STARTED then
        opts = {
          w2h_url:           Rails.application.routes.url_helpers.root_url,
          registration_url:  Rails.application.routes.url_helpers.new_user_registration_url,
          notifications_url: Rails.application.routes.url_helpers.edit_users_notifications_url,
        }
        send_messages("chatbot.responses.get_started", opts)
      when Postbacks::HELP_PAYLOAD
        settings = User::Settings.new(user)
        message = ""
        message += I18n.t("chatbot.responses.help.upcoming" + "\n", locale: user.locale) if settings.can_notify_upcoming_event?
        message += I18n.t("chatbot.responses.help.new" + "\n",      locale: user.locale) if settings.can_notify_new_event?
        message += I18n.t("chatbot.responses.help.rest",            locale: user.locale, help_url: help_url)
      else random_message("chatbot.responses.dont_understand")
      end
    end


    def handle_optin
      ChatbotOperation::UserSignUp.(@msg)
      first_name = user.first_name
      settings = User::Settings.new(user)
      message = I18n.t("chatbot.responses.onboarding.greeting",         locale: user.locale, first_name: first_name)
      message += "\n" + I18n.t("chatbot.responses.onboarding.upcoming", locale: user.locale) if settings.can_notify_upcoming_event?
      message += "\n" + I18n.t("chatbot.responses.onboarding.new",      locale: user.locale) if settings.can_notify_new_event?
      message += "\n" + I18n.t("chatbot.responses.onboarding.rest",     locale: user.locale, help_url: help_url)
      MultiMessageJob.perform_later(fbid, message)
    end

    def handle_unregistered_user
      info_url          = Rails.application.routes.url_helpers.root_url
      registration_url  = Rails.application.routes.url_helpers.new_user_registration_url
      notifications_url = Rails.application.routes.url_helpers.edit_users_notifications_url
      message = I18n.t("chatbot.responses.please_register",
                       locale:            profile.w2h_locale,
                       first_name:        profile.first_name,
                       notifications_url: notifications_url,
                       info_url:          info_url,
                       registration_url:  registration_url)
      MultiMessageJob.perform_later(fbid, message)
    end

    ##########################
    # Message Utils
    ##########################

    def list_matcher(locale_key, l, only_at_start = true)
      /#{only_at_start ? "^" : ""}(#{I18n.t(locale_key, locale: l).map{ |str| Regexp.escape(str) }.join("|")})/i
    end

    def random_message(locale_key, locals = {})
      text = I18n.t(locale_key, {locale: locale}.merge(locals)).sample
      MultiMessageJob.perform_later(fbid, text)
    end

    def send_messages(locale_key, local = {})
      text = I18n.t(locale_key, {locale: locale}.merge(local))
      MultiMessageJob.perform_later(fbid, text)
    end

    def user
      @user ||= get_user
    end

    def locale
      @locale ||= (user&.locale || get_user_locale)
    end

    def chatbot_cli
      @chatbot_cli ||= Chatbot::Client.new
    end

    def profile
      @profile ||= chatbot_cli.get_profile(fbid)
    end

    def get_user
      User.find_by(facebook_id: fbid)
    end

    def get_user_locale
      profile.w2h_locale
    end

    def help_url
      Rails.application.routes.url_helpers.edit_users_notifications_url
    end

    class MultiMessageJob < ApplicationJob
      WAIT_TIME = 0.2
      def perform(fb_id, message)
        client = Chatbot::Client.new
        ActiveRecord::Base.connection_pool.with_connection do
          message.split("\n\n").each do |step_text|
            Rails.logger.debug("Sending step text: #{step_text}")
            client.text(fb_id, step_text)
            sleep(WAIT_TIME)
          end
        end
      end
    end
  end
end
