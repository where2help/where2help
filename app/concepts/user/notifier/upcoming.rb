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
      shift.notifications.create(notified_at: Time.now, notification_type: :upcoming_event, user_id: user.id)
    end
  end
end
