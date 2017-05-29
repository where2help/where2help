module Chatbot
  class Repo
    def unsent
      BotMessage.where(sent_at: nil)
    end

    def current_failed_messages
      BotMessage.includes(:account)
        .where(
          from_bot: true,
          sent_at:  nil
        )
        .where.not(
          last_send_attempt: nil
        )
    end

    def log_message_error(chatbot_message, body, time)
      chatbot_message.update_attributes(
        last_send_attempt: time,
        error_message: body
      )
    end

    def log_sent(chatbot_message, time)
      chatbot_message.update_attributes(
        sent_at: time
      )
    end
  end
end
