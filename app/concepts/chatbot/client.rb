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
    record_message(fb_id, msg)
  end

  def record_message(fb_id, msg)
    acct = FacebookAccount.find_by(facebook_id: fb_id)
    return if acct.nil?
    acct.bot_messages.create(provider: :facebook, from_bot: true, payload: msg)
  end
end
