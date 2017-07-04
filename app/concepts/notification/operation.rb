class Notification::Operation
  class Create < ::Operation
    def process(parent:, type:, user_id:, immediate: false, **)
      notif = parent.notifications.create(notified_at: Time.now, notification_type: type, user_id: user_id)
      send_notification(notif, user_id) if immediate
    end

    def send_notification(notif, user_id)
      Notification.transaction do
        template = Notification::Presenter.new(notif)
        msg      = template.present
        user     = User.find(user_id)
        bot      = Chatbot::Client.new
        btn_text = I18n.t("chatbot.notifications.view", locale: user.locale)
        btn      = bot.make_url_button(btn_text, msg.url)
        bot.send_button_template(user, msg.text, [btn])
        notif.update_attributes(sent_at: Time.now)
      end
    end
  end
end
