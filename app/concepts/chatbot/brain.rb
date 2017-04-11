class Chatbot
  class Brain
    def hear(msg)
      case msg
      when MessengerClient::Message::Optin then handle_optin(msg)
      else
        puts "Just heard msg:\n#{msg.inspect}\n"
      end
    end

    def handle_optin(msg)
      fb_acct = FacebookAccount.includes(:user).find_by(referencing_id: msg.ref)
      fb_acct.update_attribute(:facebook_id, msg.sender.id)
      cli = MessengerClient::Client.new(ENV.fetch("FB_MESSENGER_PAGE_TOKEN"))
      cli.text(recipient_id: msg.sender.id, text: "Hi #{fb_acct.user.first_name}, you're connected to Where2Help!")
    end
  end
end
