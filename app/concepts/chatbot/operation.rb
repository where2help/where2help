class ChatbotOperation
  class Challenge < Operation
    Response = Struct.new(:success, :payload)
    def process(params)
      if !correct_mode?(params) || !challenge_matches?(params)
        @model = failure_request
      else
        @model = Response.new(true, challenge(params))
      end
    end

    private

    def challenge(params)
      params["hub.challenge"]
    end

    def failure_request
      Response.new(false)
    end

    def correct_mode?(params)
      params["hub.mode"] == "subscribe"
    end

    def challenge_matches?(params)
      token = params["hub.verify_token"]
      token == ENV.fetch("FB_CHALLENGE")
    end
  end

  class Message < Operation
    def process(params)
      brain    = Chatbot::Brain.new
      parser   = MessengerClient::MessageParser.new(params)
      messages = parser.parse
      messages.each do |msg|
        record_message(msg)
        brain.hear(msg)
      end
    end

    private

    def record_message(msg)
      user_id = msg.sender.id
      fb_acct = FacebookAccount.find_by(facebook_id: user_id)
      return if fb_acct.nil?
      fb_acct.bot_messages.create(provider: :facebook, payload: msg.to_h, from_bot: false)
    end
  end

  class UserSignUp < Operation
    class OnboardingMessageJob < ApplicationJob
      WAIT_TIME = 1
      def perform(ref, fb_id)
        client = Chatbot::Client.new
        ActiveRecord::Base.connection_pool.with_connection do
          fb_acct = FacebookAccount.includes(:user).find_by(referencing_id: ref)
          fb_acct.update_attribute(:facebook_id, fb_id)
          user       = fb_acct.user
          first_name = user.first_name
          help_url   = Rails.application.routes.url_helpers.users_notifications_url
          steps = I18n.t("chatbot.onboarding", locale: user.locale, first_name: first_name, help_url: help_url)
          steps.split("\n\n").each do |step_text|
            client.text(fb_id, step_text)
            sleep(WAIT_TIME)
          end
        end
      end
    end

    def process(msg)
      ref   = msg.ref
      fb_id = msg.sender.id
      OnboardingMessageJob.perform_later(ref, fb_id)
    end
  end
end
