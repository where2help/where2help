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
        if @model.users.include?(user)
          return @model.users.destroy(user)
        end
        @model.users << user
      end
    end
  end
end

