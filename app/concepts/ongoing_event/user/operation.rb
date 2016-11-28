class OngoingEventOperation
  class User
    class Index < Operation
      def setup_model!(params)
        @model = OngoingEvent.published.newest_first
      end
    end

    class Show < Operation
      def setup_model!(params)
        @model = OngoingEvent.published.find(params[:event_id])
      end
    end

    class OptIn < Operation
      def process(params)
        user   = params.fetch(:current_user)
        @model = user.ongoing_events.find(params.fetch(:event_id))
        if @model.participations.include?(user)
          return @model.participations.destroy(user)
        end
        @model.participations << user
      end
    end
  end
end
