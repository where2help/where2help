class EventsController < ApplicationController
  before_action :authenticate_user!


  def show
    @event = Event.published.find(params[:id])
  end


  def index
    @events = Event.with_available_shifts.page(params[:page])

    if params[:last_date] && params[:last_date].to_date == @events.first.starts_at.to_date
      @dayswitch = false
    else
      @dayswitch = true
    end
  end
end
