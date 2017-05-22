module Chatbot
  class Brain
    attr_reader :fbid

    def hear(msg)
      Rails.logger.debug("Chatbot::Brain received: #{msg.inspect}")
      @fbid = msg.sender.id
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
      return handle_unregistered_user(msg) if user.nil?
      case msg.text
      when list_matcher("chatbot.user.help", locale)
        send_messages(msg, "chatbot.responses.help", help_url: help_url)
      when list_matcher("chatbot.user.hello", locale)
        random_message(msg, "chatbot.responses.hello")
      else
        random_message(msg, "chatbot.responses.dont_understand")
      end
    end

    def handle_postback(msg)
      return handle_unregistered_user(msg) if user.nil?
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


    def handle_optin(msg)
      ChatbotOperation::UserSignUp.(msg)
      first_name  = user.first_name
      message     = I18n.t("chatbot.responses.onboarding", locale: user.locale, first_name: first_name, help_url: help_url)
      MultiMessageJob.perform_later(fbid, message)
    end

    def handle_unregistered_user(msg)
      info_url          = Rails.application.routes.url_helpers.root_url
      registration_url  = Rails.application.routes.url_helpers.new_user_registration_url
      notifications_url = Rails.application.routes.url_helpers.users_notifications_url
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
      /#{only_at_start ? "^" : ""}(#{I18n.t(locale_key, locale: l).join("|")})/i
    end

    def random_message(msg, locale_key, locals = {})
      text = I18n.t(locale_key, {locale: locale}.merge(locals)).sample
      MultiMessageJob.perform_later(fbid, text)
    end

    def send_messages(msg, locale_key, local = {})
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
      fb_acct = FacebookAccount.includes(:user).find_by(facebook_id: fbid)
      return nil if fb_acct.nil?
      fb_acct.user
    end

    def get_user_locale
      profile.w2h_locale
    end

    def help_url
      Rails.application.routes.url_helpers.users_notifications_url
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
