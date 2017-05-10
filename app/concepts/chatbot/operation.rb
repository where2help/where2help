class ChatbotOperation
  class Initialize < Operation
    def process(_opts)
      # Setup defaults for chatbot
      bot = Chatbot::Client.new
      # Get Started (needs to happen before menu)
      bot.set_get_started
      # Persistent Menu
      bot.set_persistent_menu
    end
  end

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
        begin
          record_message(msg)
          brain.hear(msg)
        rescue Exception => e
          Rails.logger.error("Chatbot::Operation::Message Error: #{e}")
          Rails.logger.error(e.backtrace.join("\n"))
        end
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
    def process(msg)
      ref   = msg.ref
      fb_id = msg.sender.id
      fb_acct = FacebookAccount.includes(:user).find_by(referencing_id: ref)
      fb_acct.update_attribute(:facebook_id, fb_id)
    end
  end
end
