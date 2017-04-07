class ScheduleOperation
  class ShiftPresenter
    def initialize(shift) @shift = shift    end
    def type()            :shift            end
    def order_by()        @shift.starts_at  end
  end

  class OngongEventPresenter
    def initialize(event) @event = event    end
    def type()            :ongoing_event    end
    def order_by()        @event.created_at end
  end

  class Index < Operation
    def setup_model!(params)
      current_user = params.fetch(:current_user)
      scope = params[:filter].try(:to_sym)
      scope = :upcoming if scope.nil?
      case scope
      when :past, :upcoming
        items  = current_user.shifts.send(scope).map { |s| ShiftPresenter.new(s) }
        @model = paginate(items)
      when :all
        shifts = current_user.shifts.all.map { |s| ShiftPresenter.new(s) }
        events = current_user.ongoing_events.published.map { |s| OngongEventPresenter.new(s) }
        items  = (shifts + events).sort_by { |item| item.order_by }
        @model = paginate(items)
      when :ongoing
        items  = current_user.ongoing_events.published.newest_first.map { |s| OngongEventPresenter.new(s) }
        @model = paginate(items)
      else
        raise ArgumentError.new('Invalid scope given')
      end
    end

    private

    def paginate(items)
      Kaminari.paginate_array(items)
    end
  end
end
