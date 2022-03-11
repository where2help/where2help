class Event::List
  def self.call(filter:, page:, last_date:)
    query = nil
    if filter == "available"
      query = Event.with_available_shifts
    else
      query = Event.with_upcoming_shifts
    end

    events = Kaminari.paginate_array(query).page(page)
    last_event_date = last_date.try(:to_date)

    Struct.new(:events, :last_event_date).new(events, last_event_date)
  end
end
