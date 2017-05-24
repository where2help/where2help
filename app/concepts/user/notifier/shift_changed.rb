module User::Notifier
  class ShiftChanged
    def self.call(shifts:)
      shifts.each do |shift|
        shift.users.each do |user|
          Worker.perform_later(shift, user)
        end
      end
    end

    class Worker < ApplicationJob
      def perform(shift, user)
        ActiveRecord::Base.connection_pool.with_connection do
          ShiftChanged.new.notify!(user, shift)
        end
      end
    end

    def initialize
      @cli = Chatbot::Client.new
    end

    def notify!(user, shift)
      settings = User::Settings.new(user)
      Rails.logger.info("Updating users about updated event")
      return unless settings.can_notify_updated_event?
      Rails.logger.info("User has notification settings set")
      was_notified = false
      if settings.can_notify_facebook?
        Rails.logger.info("User has notification settings set")
        send_bot_message(shift, user)
        was_notified = true
      end

      if settings.can_notify_email?
        UserMailer.shift_updated(shift, user).deliver_later
        was_notified = true
      end

      if was_notified
        shift.notifications.create(notified_at: Time.now, notification_type: :updated_shift, user_id: user.id)
      end
    end

    def send_bot_message(shift, user)
      event      = shift.event
      event_link = make_event_link(event)
      msg        = I18n.t("chatbot.shifts.updated.text",
                          title:      event.title,
                          link:       event_link,
                          date:       Utils.pretty_date(shift.starts_at),
                          starts_at:  Utils.pretty_time(shift.starts_at),
                          ends_at:    Utils.pretty_time(shift.ends_at),
                          locale:     user.locale)
      btn_text = I18n.t("chatbot.shifts.updated.button_text")
      Rails.logger.info("Sending bot message #{msg} to user #{user.id}")
      button   = MessengerClient::URLButton.new(btn_text, event_link)
      @cli.send_button_template(user, msg, [button])
    end

    def make_event_link(event)
      Rails.application.routes.url_helpers.event_url(event)
    end
  end
end
