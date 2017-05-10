module Chatbot
  class Client
    attr_reader :client

    def initialize
      @client = MessengerClient::Client.new(ENV.fetch("FB_MESSENGER_PAGE_TOKEN"))
    end

    def set_get_started
      client.set_get_started(Postbacks::GET_STARTED)
    end

    def set_persistent_menu
      menu = Menu.new
      menu_json = menu.to_json
      client.profile_post(menu_json)
    end

    def send_text(user, msg)
      fb_id = user.facebook_account&.facebook_id
      return if fb_id.nil?
      text(fb_id, msg)
    end

    def send_button_template(user, text, buttons)
      fb_id = user.facebook_account&.facebook_id
      return if fb_id.nil?
      tpl  = MessengerClient::ButtonTemplate.new(text, buttons)
      data = tpl.to_json
      client.send(fb_id, data)
      record_message(fb_id, data)
    end

    def text(fb_id, msg)
      client.text(recipient_id: fb_id, text: msg)
      record_message(fb_id, msg)
    end

    def get_profile(fb_id, scopes = %w(locale first_name last_name timezone))
      res = client.get_profile(facebook_id: fb_id, scopes: scopes)
      FacebookUser.new(res)
    end

    def record_message(fb_id, msg)
      acct = FacebookAccount.find_by(facebook_id: fb_id)
      return if acct.nil?
      acct.bot_messages.create(provider: :facebook, from_bot: true, payload: msg)
    end
  end
end
