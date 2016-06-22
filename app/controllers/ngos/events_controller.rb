class Ngos::EventsController < ApplicationController
  before_action :authenticate_ngo!

  def show
    set_ngo_event
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
    @event = current_ngo.events.includes(shifts: [:users]).find(params[:id])
  end

  def update
    set_ngo_event
    if @event.update_attributes(event_params)
      redirect_to [:ngos, @event], notice: t('ngos.events.messages.updated_successfully')
    else
      render 'edit'
    end
  end

  def destroy
    set_ngo_event.destroy
    redirect_to action: :index
  end

  def publish
    set_ngo_event
    if @event.publish!
      redirect_to [:ngos, @event], notice: 'Das Event wurde erfolgreich publiziert.'
    else
      redirect_to [:ngos, @event], notice: 'Das Event konnte nicht publiziert werden.'
    end
  end

  def cal
    @event = Event.find(params[:id])
    cal = RiCal.Calendar do |cal|
      cal.event do |event|
        event.summary      = @event.title
        event.description  = @event.description
        event.dtstart      = @event.starts_at
        event.dtend        = @event.ends_at
        event.location     = @event.address
        event.url          = ngos_event_url(@event)
        event.add_attendee current_ngo.email
        event.alarm do |alarm|
          alarm.description = @event.title
        end
      end
    end
    respond_to do |format|
      format.ics { send_data(cal.export, :filename=>"cal.ics", :disposition=>"inline; filename=cal.ics", :type=>"text/calendar")}
    end
  end

  private

  def event_params
    params.require(:event).permit(
      :title, :description, :address, :lat, :lng,
      shifts_attributes: [:id, :volunteers_needed, :starts_at, :ends_at, :_destroy]
    )
  end

  def set_ngo_event
    @event = current_ngo.events.find(params[:id])
  end
end
