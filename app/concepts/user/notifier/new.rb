module User::Notifier
  class New
    def self.call(event)
      Worker.perform_later(event)
    end

    class Worker < ApplicationJob
      def perform(event)
        ActiveRecord::Base.connection_pool.with_connection do
          New.new.notify!(event)
        end
      end
    end

    attr_reader :chatbot_cli

    def initialize
      @chatbot_cli = Chatbot::Client.new
    end

    def notify!(event)
      nids = notified_user_ids(event)
      User.where.not(id: nids).each do |u|
        notify_new(u, event)
      end
    end

    private

    def notified_user_ids(event)
      event
        .notifications
        .joins(:user)
        .where(notification_type: :new_event)
        .pluck(:user_id)
    end

    def notify_new(user, event)
      event.notifications.create(notified_at: Time.now, notification_type: :new_event, user_id: user.id)
    end
  end
end
