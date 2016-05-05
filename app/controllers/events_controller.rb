class EventsController < ApplicationController
  before_action :authenticate_user!


  def show
    @event = Event.find(params[:id])
  end


  def index
    # @events = current_ngo.events
    # filter_by = params[:filter_by]
    # if filter_by == 'upcoming'
    #   @events = @events.where(id: Shift.where("starts_at >= ?", Time.now).pluck(:event_id).uniq)
    # elsif filter_by == 'past'
    #   @events = @events.where(id: Shift.where("starts_at < ?", Time.now).pluck(:event_id).uniq)
    # end
    # order_by = params[:order_by]
    # if order_by
    #   @events = @events.order(order_by)
    # end
  end
end
