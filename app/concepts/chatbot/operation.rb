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
    attr_reader :client

    def initialize
      @client = Chatbot::Client.new
    end

    def process(msg)
      fb_acct = FacebookAccount.includes(:user).find_by(referencing_id: msg.ref)
      fb_id   = msg.sender.id
      fb_acct.update_attribute(:facebook_id, fb_id)
      client.text(fb_id, "Hi #{fb_acct.user.first_name}, you're connected to Where2Help!")
    end
  end
end
