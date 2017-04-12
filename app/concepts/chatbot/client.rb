class Chatbot::Client
  def initialize
    @client = MessengerClient::Client.new(ENV.fetch("FB_MESSENGER_PAGE_TOKEN"))
  end

  def send_text(user, msg)
    fb_id = user.facebook_account&.facebook_id
    return if fb_id.nil?
    text(fb_id, msg)
  end

  def text(fb_id, msg)
    @client.text(recipient_id: fb_id, text: msg)
  end
end
