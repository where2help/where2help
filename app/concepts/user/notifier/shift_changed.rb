require "notification/operation"
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
      NotificationOperation::Create.(parent: shift, type: :updated_shift, user_id: user.id, immediate: true)
    end
  end
end
