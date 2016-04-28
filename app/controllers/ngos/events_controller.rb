class Ngos::EventsController < ApplicationController
  before_action :authenticate_ngo!, only: [:new, :create, :index]


  def show
    @event = Event.find(params[:id])
  end


  def index
    @events = current_ngo.events
    filter_by = params[:filter_by]
    if filter_by == 'upcoming'
      @events = @events.where(id: Shift.where("starts_at >= ?", Time.now).pluck(:event_id).uniq)
    elsif filter_by == 'past'
      @events = @events.where(id: Shift.where("starts_at < ?", Time.now).pluck(:event_id).uniq)
    end
    order_by = params[:order_by]
    if order_by
      @events = @events.order(order_by)
    end
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
      redirect_to [:ngos, @event], notice: t('ngos.events.messages.created_successfully')
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
      redirect_to [:ngos, @event], notice: t('ngos.events.messages.updated_successfully')
    else
      render 'edit'
    end
  end


  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to action: :index
  end


  def publish
    @event = Event.find(params[:id])
    if @event.publish!
      redirect_to [:ngos, @event], notice: 'Das Event wurde erfolgreich publiziert.'
    else
      redirect_to [:ngos, @event], notice: 'Das Event konnte nicht publiziert werden.'
    end
  end

  private

  def event_params
    params.require(:event).permit(
      :title, :description, :address, :shift_length, :lat, :lng,
      shifts_attributes: [:id, :volunteers_needed, :starts_at, :ends_at, :_destroy]
    )
  end
end
