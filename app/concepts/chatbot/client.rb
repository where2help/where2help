module Chatbot
  class Client
    attr_reader :client

    def initialize(send_immediately = ENV.fetch("SEND_BOT_MESSAGES_IMMEDIATELY", false))
      @send_immediately = send_immediately.to_s == "true"
      @client           = MessengerClient::Client.new(ENV.fetch("FB_MESSENGER_PAGE_TOKEN"))
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

    def text(fb_id, msg)
      send_later(fb_id, text: msg)
    end

    def send_button_template(user, text, buttons)
      fb_id = user.facebook_account&.facebook_id
      return if fb_id.nil?
      tpl  = MessengerClient::ButtonTemplate.new(text, buttons)
      data = tpl.to_json
      send_later(fb_id, data)
    end

    def send_later(recipient_id, data)
      acct = FacebookAccount.find_by(facebook_id: recipient_id)
      if acct.present?
        bot_message = acct.bot_messages.create(
          from_bot:   false,
          payload:    data
        )
        send_message(bot_message) if send_immediately?
      else
        Rails.logger.warn("Chatbot::Client#send_later - Couldn't find account for FB ID #{recipient_id.inspect}")
      end
    end

    def send_immediately?
      @send_immediately
    end

    def get_profile(fb_id, scopes = %w(locale first_name last_name timezone))
      res = client.get_profile(facebook_id: fb_id, scopes: scopes)
      log_res(res)
      FacebookUser.new(res)
    end

    def send_message(chatbot_message, now = Time.now)
      payload      = chatbot_message.payload
      recipient_id = chatbot_message.account.facebook_id
      res = @client.send(recipient_id, payload)
      repo = Chatbot::Repo.new
      if res.success?
        repo.log_sent(chatbot_message, time)
      else
        repo.new.log_message_error(chatbot_message, res.body, now)
      end
      log_res(res, chatbot_message_id: chatbot_message.id)
      res
    end

    def log_res(res, opts = {})
      Rails.logger.info("FB MESSENGER RESPONSE #{res.success? ? '' : 'UN'}SUCCESSFUL (#{res.code})\nBODY: #{res.body}\nOPTS: #{opts.inspect}")
    end
  end
end
