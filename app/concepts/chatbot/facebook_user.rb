module Chatbot
  class FacebookUser
    def initialize(fb_id)
      @fb_id = fb_id
      @client = MessengerClient::Client.new
    end

    def retrieve
      @client.get_profile(@fb_id, [:first_name, :last_name, :locale, :timezone])
    end
  end
end
