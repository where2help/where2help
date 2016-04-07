class Ngos::EventsController < ApplicationController
  before_action :authenticate_ngo!, only: [:new, :create, :index]

  def new
    @event = Event.new
    t = Time.now + 15.minutes
    t = t - t.sec - t.min%15*60
    @event.shifts.build(volunteers_needed: 1, starts_at: t, ends_at: t + 2.hours)
  end

  def show
    @event = Event.find(params[:id])
  end

  def index
    @events = current_ngo.events
  end

  def create
    @event = Event.new(event_params)
    @event.ngo = current_ngo
    respond_to do |format|
      if @event.save
        format.html { redirect_to [:ngos, @event], notice: 'Event was successfully created.' }
      else
        format.html { render action: :new }
      end
    end
  end

  private

  def event_params
    params.require(:event).permit(
      :title, :description, :address, :shift_length,
      shifts_attributes: [:id, :volunteers_needed, :starts_at, :ends_at]
    )
  end
end
