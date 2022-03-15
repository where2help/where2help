require "ongoing_event/progress_bar_helper"

class OngoingEventOperation
  class User
    class Index < Operation
      include ProgressBarHelper

      def setup_model!(params)
        @model = OngoingEvent
          .published
          .newest_first
          .where(
            ongoing_event_category_id: params[:ongoing_event_category_id],
          )
          .where.not(id: blocked_event_ids(params[:user]))
      end

      private

      def blocked_event_ids(user)
        OngoingEvent.joins(ngo: :user_blocks).where(ngo_user_blocks: { user_id: user.id }).pluck(:id)
      end
    end

    class Show < Operation
      include ProgressBarHelper

      def setup_model!(params)
        @model = OngoingEvent.published.find(params[:event_id])
      end
    end

    class OptIn < Operation
      def process(params)
        user = params.fetch(:current_user)
        @model = OngoingEvent.find_by(id: params.fetch(:event_id))
        return nil if @model.nil?
        raise ArgumentError, "User already opted in" if @model.users.include?(user)
        @model.users << user
        notify_ngo!(@model.ngo, @model, user)
      end

      private

      def notify_ngo!(ngo, ongoing_event, user)
        NgoMailer
          .ongoing_event_opt_in(
            ngo: ngo,
            ongoing_event: ongoing_event,
            user: user,
          ).deliver_later
      end
    end

    class OptOut < Operation
      def process(params)
        user = params.fetch(:current_user)
        @model = OngoingEvent.find_by(id: params.fetch(:event_id))
        return nil if @model.nil?
        @model.users.destroy(user) if @model.users.include?(user)
      end
    end
  end
end
