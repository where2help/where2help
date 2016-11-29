class ScheduleOperation
  class Index < Operation
    def setup_model!(params)
      current_user = params.fetch(:current_user)
      scope = params[:filter].try(:to_sym)
      scope = :upcoming if scope.nil?
      case scope
      when :all, :past, :upcoming
        @model = Shift.send(scope)
      when :ongoing
        @model = current_user.ongoing_events.published.newest_first
      else
        raise ArgumentError.new('Invalid scope given')
      end
    end
  end
end
