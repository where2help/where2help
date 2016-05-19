class EventsController < ApplicationController
  before_action :authenticate_user!


  def show
    @event = Event.published.find(params[:id])
  end


  def index
    unpaginated_events = Event.published.
                               includes(shifts: [:users]).
                               where('shifts.volunteers_needed > shifts.volunteers_count').
                               where('shifts.starts_at > NOW()').
                               order('shifts.starts_at ASC').
                               to_a
    @events = Kaminari.paginate_array(unpaginated_events).page(params[:page])

    if params[:last_date] && params[:last_date].to_date == @events.first.starts_at.to_date
      @dayswitch = false
    else
      @dayswitch = true
    end
  end
end
