class Chatbot::Brain
  def hear(msg)
    case msg
    when MessengerClient::Message::Optin then ChatbotOperation::UserSignUp.(msg)
    when MessengerClient::Message::Text  then handle_text_message(msg)
    else
      puts "Just heard msg:\n#{msg.inspect}\n"
    end
  end

  def handle_text_message(msg)
    cli    = Chatbot::Client.new
    fb_id  = msg.sender.id
    user   = FacebookAccount.includes(:user).find_by(facebook_id: fb_id).user
    locale = user.locale
    case msg.text
    when /\A#{I18n.t("chatbot.user_hello", locale: locale).join("|")}/i
      cli.text(fb_id, I18n.t("chatbot.hello", locale: locale).sample)
    else
      cli.text(fb_id, I18n.t("chatbot.dont_understand", locale: locale).sample)
    end
  end
end
