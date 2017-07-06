module NotificationOperation
  class Create < Operation
    def process(parent:, type:, user_id:, immediate: false, **)
      notif = parent.notifications.create(notified_at: Time.now, notification_type: type, user_id: user_id)
      send_notification(notif, user_id) if immediate
    end

    def send_notification(notif, user_id)
      user = User.find(user_id)
      settings = User::Settings.new(user)
      was_user_notified = false
      if settings.can_notify_facebook?
        was_user_notified = true
        send_bot_message(notif, user)
      end
      if settings.can_notify_email?
        was_user_notified = true
        send_email(notif, user)
      end
      if was_user_notified
        notif.update_attributes(sent_at: Time.now)
      end
    end

    private

    def send_bot_message(notif, user)
      template = Notification::Presenter.new(notif)
      msg      = template.present
      bot      = Chatbot::Client.new
      btn_text = I18n.t("chatbot.notifications.view", locale: user.locale)
      btn      = bot.make_url_button(btn_text, msg.url)
      bot.send_button_template(user, msg.text, [btn])
    end

    def send_email(notif, user)
      batcher = Notification::Batcher.new
      template = batcher.present_notifications([notif])
      UserMailer.batch_notifications(
        user: user,
        notifications: template.parts.map(&:to_h)
      ).deliver_later
    end
  end
end
