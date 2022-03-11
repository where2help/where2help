class EventsController < ApplicationController
  before_action :authenticate_user!

  def show
    @event = Event.published.find(params[:id])
  end

  def index
    list = Event::List.(filter: params[:filter], page: params[:page], last_date: params[:last_date])

    @events = list.events
    @last_event_date = list.last_event_date
  end
end
