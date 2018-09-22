# frozen_string_literal: true

class EventOperation
  class Ngo
    class Update < Operation
      def setup_model!(ngo:, event_id:, **)
        @model = ngo.events
                    .includes(shifts: [:users])
                    .find(event_id)
      end

      def process(ngo:, event_id:, event:, notify_users:, **)
        @model = ngo.events.find(event_id)
        @model.update_attributes(event)
        notify_users! if notify_users
      end

      def has_users?
        has_users = false
        @model.shifts.each do |s|
          if s.volunteers_count > 0
            has_users = true
            break
          end
        end
        has_users
      end

      def user_count
        @model.shifts.reduce(0) { |sum, s| sum + s.volunteers_count }
      end

      def pluralized_users
        user_count == 1 ?
          I18n.t("activerecord.models.users.one") :
          I18n.t("activerecord.models.users.other")
      end

      private

      def notify_users!
        users = @model.shifts.flat_map(&:users).uniq
        users.each do |user|
          UserMailer.event_updated(event: @model, user: user).deliver_later
        end
      end
    end
  end
end
