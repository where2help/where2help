class EventsController < ApplicationController
  before_filter :authenticate_ngo!, only: :new

  def new
    @event = Event.new
    #@event.shifts.build(volunteers_needed: 1, starts_at: Time.now, ends_at: 2.hours.from_now)
  end
end
