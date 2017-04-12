require "operation"
class Chatbot
  class Brain
    def hear(msg)
      case msg
      when MessengerClient::Message::Optin then ChatbotOperation::UserSignUp.(msg)
      else
        puts "Just heard msg:\n#{msg.inspect}\n"
      end
    end
  end
end
