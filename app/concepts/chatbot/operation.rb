class ChatbotOperation
  class Challenge < Operation
    Response = Struct.new(:success, :payload)
    def process(params)
      mode = params["hub.mode"]
      @model = Response.new
      if mode == "subscribe"
        challenge = params["hub.challenge"]
        token = params["hub.verify_token"]
        if token == ENV.fetch("FB_CHALLENGE")
          @model.success = true
          @model.payload = challenge
          return
        end
      end
      @model.success = false
    end
  end

  class Message < Operation
    def process(params)
    end
  end
end
