class Event::List
  def self.call(filter:, page:, last_date:, user:)
    blocked_event_ids = blocked_event_ids_for(user)
    query = nil
    if filter == "available"
      query = Event.with_available_shifts
    else
      query = Event.with_upcoming_shifts
    end

    events = Kaminari
      .paginate_array(query.where.not(id: blocked_event_ids))
      .page(page)

    last_event_date = last_date.try(:to_date)

    Struct.new(:events, :last_event_date).new(events, last_event_date)
  end

  private

  def self.blocked_event_ids_for(user)
    Event
      .joins(ngo: :user_blocks)
      .where(ngo_user_blocks: { user_id: user.id })
      .pluck(:id)
  end
end
