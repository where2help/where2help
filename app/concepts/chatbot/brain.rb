module Chatbot
  class Brain
    def hear(msg)
      Rails.logger.debug("Chatbot::Brain received: #{msg.inspect}")
      case msg
      when MessengerClient::Message::Optin    then handle_optin(msg)
      when MessengerClient::Message::Text     then handle_text_message(msg)
      when MessengerClient::Message::Postback then handle_postback(msg)
      else
        Rails.logger.warn "Chatbot::Brain#hear doesn't know how to handle: #{msg.inspect}"
        random_message(msg, "chatbot.responses.dont_understand")
        send_messages(msg, "chatbot.responses.help", help_url: help_url)
      end
    end

    ##########################
    # Handlers
    ##########################

    def handle_text_message(msg)
      fb_id, user = get_user(msg)
      locale = get_locale(fb_id, user)
      case msg.text
      when /\A#{I18n.t("chatbot.user_hello", locale: locale).join("|")}/i
        random_message(msg, "chatbot.responses.hello")
      else
        random_message(msg, "chatbot.responses.dont_understand")
      end
    end

    def handle_postback(msg)
      case msg.postback.to_s
      when Postbacks::GET_STARTED then
        opts = {
          w2h_url:           Rails.application.routes.url_helpers.root_url,
          registration_url:  Rails.application.routes.url_helpers.new_user_registration_url,
          notifications_url: Rails.application.routes.url_helpers.users_notifications_url,
        }
        send_messages(msg, "chatbot.responses.get_started", opts)
      when Postbacks::HELP_PAYLOAD then send_messages(msg, "chatbot.responses.help", help_url: help_url)
      else random_message(msg, "chatbot.responses.dont_understand")
      end
    end

    def help_url
      Rails.application.routes.url_helpers.users_notifications_url
    end

    def handle_optin(msg)
      ChatbotOperation::UserSignUp.(msg)
      fb_id, user = get_user(msg)
      first_name  = user.first_name
      message     = I18n.t("chatbot.responses.onboarding", locale: user.locale, first_name: first_name, help_url: help_url)
      Chatbot::Brain::MultiMessageJob.perform_later(fb_id, message)
    end

    ##########################
    # Message Utils
    ##########################

    def random_message(msg, locale_key, locals = {})
      fb_id, user = get_user(msg)
      locale      = get_locale(fb_id, user)
      text        = I18n.t(locale_key, {locale: locale}.merge(locals)).sample
      MultiMessageJob.perform_later(fb_id, text)
    end

    def send_messages(msg, locale_key, local = {})
      fb_id, user = get_user(msg)
      locale      = get_locale(fb_id, user)
      text        = I18n.t(locale_key, {locale: locale}.merge(local))
      MultiMessageJob.perform_later(fb_id, text)
    end

    def get_user(msg)
      fb_id   = msg.sender.id
      fb_acct = FacebookAccount.includes(:user).find_by(facebook_id: fb_id)
      if fb_acct.nil?
        [fb_id, nil]
      else
        [fb_id, fb_acct.user]
      end
    end

    def get_locale(fb_id, user)
      return get_user_locale(fb_id) if user.nil?
      user.locale
    end

    def get_user_locale(fb_id)
      client  = Chatbot::Client.new
      profile = client.get_profile(fb_id)
      locale  = Locale.from_facebook(profile["locale"])
      locale.locale
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
