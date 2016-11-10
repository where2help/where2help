class EventsController < ApplicationController
  before_action :authenticate_user!

  def show
    @event = Event.published.find(params[:id])
  end

  def index
    @events = Kaminari.paginate_array(Event.with_available_shifts).page(params[:page])
    @last_event_date = params[:last_date].try(:to_date)
  end
end
