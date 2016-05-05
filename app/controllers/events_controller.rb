class EventsController < ApplicationController
  before_action :authenticate_user!


  def show
    @event = Event.find(params[:id])
  end


  def index
    @events = Event.
      where(state: 'published').
      includes(shifts: [:users]).
      where('shifts.volunteers_needed > shifts.volunteers_count').
      where('shifts.starts_at > NOW()').
      order('shifts.starts_at ASC').
      page(params[:page])
  end
end
