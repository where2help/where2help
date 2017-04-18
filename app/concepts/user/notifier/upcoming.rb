class User::Notifier
  class Upcoming
    WHEN_UPCOMING = -> { Time.now + 1.day }

    def self.call
      new.notify_upcoming!
    end

    class Worker < ApplicationJob
      def perform
        ActiveRecord::Base.connection_pool.with_connection do
          Upcoming.new.notify_upcoming!
        end
      end
    end

    def initialize
      @chatbot_cli = Chatbot::Client.new
    end

    def notify_upcoming!
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
        msg = I18n.t("chatbot.shifts.upcoming", title: shift.event.title, starts_at: shift.starts_at, locale: user.locale)
        @chatbot_cli.send_text(user, msg)
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
  end
end
