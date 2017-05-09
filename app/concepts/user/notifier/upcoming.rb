module User::Notifier
  class Upcoming
    WHEN_UPCOMING = -> { Time.now + 1.day }

    def self.call
      new.notify!
    end

    class Worker < ApplicationJob
      def perform
        ActiveRecord::Base.connection_pool.with_connection do
          Upcoming.new.notify!
        end
      end
    end

    attr_reader :chatbot_cli

    def initialize
      @chatbot_cli = Chatbot::Client.new
    end

    def notify!
      start  = Time.now
      ending = WHEN_UPCOMING.()
      upcoming_shifts = Shift.includes(:users, [notifications: :user]).where("starts_at > ? AND starts_at < ?", start, ending)
      upcoming_shifts.each do |s|
        handle_shift(s)
      end
    end

    private

    def handle_shift(shift)
      s_users = shift.users
      n_users = shift.notifications.map(&:user)
      users_to_notify = (s_users - n_users).uniq
      users_to_notify.each do |u|
        notify_upcoming(u, shift)
      end
    end

    def notify_upcoming(user, shift)
      settings = User::Settings.new(user)
      return unless settings.can_notify_upcoming_event?
      was_notified = false
      if settings.can_notify_facebook?
        send_bot_message(user, shift)
        was_notified = true
      end
      if settings.can_notify_email?
        UserMailer.upcoming_event(user: user, shift: shift).deliver_later
        was_notified = true
      end
      if was_notified
        shift.notifications.create(notified_at: Time.now, notification_type: :upcoming_event, user_id: user.id)
      end
    end

    def send_bot_message(user, shift)
      msg        = I18n.t("chatbot.shifts.upcoming.text", title: shift.event.title, starts_at_date: pretty_date(shift.starts_at), starts_at_time: pretty_time(shift.starts_at), locale: user.locale)
      btn_text   = I18n.t("chatbot.shifts.upcoming.button_text", locale: user.locale)
      event_link = Rails.application.routes.url_helpers.event_url(shift.event)
      button     = MessengerClient::URLButton.new(btn_text, event_link)
      @chatbot_cli.send_button_template(user, msg, [button])
    end

    def pretty_date(time)
      time.strftime("%A, %d %b %Y")
    end

    def pretty_time(time)
      time.strftime("%H:%M")
    end
  end
end
