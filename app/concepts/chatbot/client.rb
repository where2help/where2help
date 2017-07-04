require "json"
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

    def make_url_button(text, url)
      MessengerClient::URLButton.new(text, url)
    end

    def send_button_template(user, text, buttons)
      fb_id = user.facebook_account&.facebook_id
      return if fb_id.nil?
      tpl  = MessengerClient::ButtonTemplate.new(text, buttons)
      data = tpl.to_json
      res  = client.send(fb_id, data)
      log_res(res)
      record_message(fb_id, data)
    end

    def send_list_template(fb_id, template_items, buttons)
      tpl = MessengerClient::ListTemplate.new(template_items, buttons, "compact")
      data = tpl.to_json
      res = client.send(fb_id, data)
      log_res(res)
      record_message(fb_id, data)
    end

    def text(fb_id, msg)
      return if fb_id.nil?
      res = client.text(recipient_id: fb_id, text: msg)
      log_res(res)
      record_message(fb_id, msg)
    end

    def get_profile(fb_id, scopes = %w(locale first_name last_name timezone))
      res = client.get_profile(facebook_id: fb_id, scopes: scopes)
      log_res(res)
      profile = JSON.load(res.body)
      FacebookUser.new(profile)
    end

    def record_message(fb_id, msg)
      acct = FacebookAccount.find_by(facebook_id: fb_id)
      return if acct.nil?
      acct.bot_messages.create(provider: :facebook, from_bot: true, payload: msg)
    end

    def log_res(res)
      Rails.logger.info("FB MESSENGER RESPONSE #{res.success? ? '' : 'UN'}SUCCESSFUL (#{res.code})\nBODY: #{res.body}")
    end
  end
end
