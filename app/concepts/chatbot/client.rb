class Chatbot::Client
  def initialize
    @client = MessengerClient::Client.new(ENV.fetch("FB_MESSENGER_PAGE_TOKEN"))
  end

  def send_text(user, msg)
    fid = user.facebook_account&.facebook_id
    return if fid.nil?
    @client.text(recipient_id: fid, text: msg)
  end
end
