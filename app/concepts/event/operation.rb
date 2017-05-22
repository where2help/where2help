class EventOperation
  class Ngo
    class Update < Operation
      def setup_model!(ngo:, event_id:, **)
        @model = ngo.events
          .includes(shifts: [:users])
          .find(event_id)
      end

      def process(ngo:, event_id:, event:, notify_users:, **)
        @model = ngo.events.includes(shifts: :users).find(event_id)
        @model.attributes = event
        notify_users! if notify_users
        @model.save!
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
        if @model.changes.any?
          return notify_event(model)
        end
        shifts =
          @model.shifts.select { |shift| shift.changes.any? }
        notify_shifts(shifts)
      end

      def notify_shifts(shifts)
        User::Notifier::ShiftChanged.(shifts: shifts)
      end

      def notify_event(event)
        User::Notifier::EventChanged.(event: event)
      end
    end
  end
end
