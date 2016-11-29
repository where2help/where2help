class OngoingEventOperation
  module User
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
        @model = OngoingEvent.find_by(id: params.fetch(:event_id))
        return nil if @model.nil?
        raise ArgumentError, "User already opted in" if @model.users.include?(user)
        @model.users << user
      end
    end

    class OptOut < Operation
      def process(params)
        user   = params.fetch(:current_user)
        @model = OngoingEvent.find_by(id: params.fetch(:event_id))
        return nil if @model.nil?
        @model.users.destroy(user) if @model.users.include?(user)
      end
    end
  end
end

