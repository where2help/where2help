module User::Notifier
  class EventChanged
    def self.call(event:)
      uniq_users(event).each do |user|
        Worker.perform_later(user, event)
      end
    end

    def self.uniq_users(event)
      event.shifts.flat_map(&:users).uniq
    end

    class Worker < ApplicationJob
      def perform(user, event)
        ActiveRecord::Base.connection_pool.with_connection do
          EventChanged.new.notify!(user, event)
        end
      end
    end

    def initialize
      @cli = Chatbot::Client.new
    end

    def notify!(user, event)
      event.notifications.create(notified_at: Time.now, notification_type: :updated_event, user_id: user.id)
    end
  end
end
