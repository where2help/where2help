class Ngos::EventsController < ApplicationController
  before_action :authenticate_ngo!, only: [:new, :create, :index]


  def show
    @event = Event.find(params[:id])
  end


  def index
    @events = current_ngo.events
  end


  def new
    @event = Event.new
    t = Time.now + 15.minutes
    t = t - t.sec - t.min%15*60
    @event.shifts.build(volunteers_needed: 1, starts_at: t, ends_at: t + 2.hours)
  end


  def create
    @event = Event.new(event_params)
    @event.ngo = current_ngo
    if @event.save
      redirect_to [:ngos, @event], notice: 'Das Event wurde erfolgreich erzeugt.'
    else
      render action: :new
    end
  end


  def edit
    @event = Event.includes(shifts: [:users]).find(params[:id])
  end


  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      redirect_to [:ngos, @event], notice: 'Das Event wurde erfolgreich aktualisiert.'
    else
      render 'edit'
    end    
  end


  private

  def event_params
    params.require(:event).permit(
      :title, :description, :address, :shift_length,
      shifts_attributes: [:id, :volunteers_needed, :starts_at, :ends_at, :_destroy]
    )
  end
end
