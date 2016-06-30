class Ngos::EventsController < ApplicationController
  before_action :authenticate_ngo!

  def show
    find_ngo_event
  end

  def index
    @events = current_ngo.events.filter(*filter_params)
  end

  def new
    @event = current_ngo.new_event
  end

  def create
    @event = current_ngo.events.new event_params
    if @event.save
      flash[:notice] = t('ngos.events.messages.create_success')
      redirect_to [:ngos, @event]
    else
      render :new
    end
  end

  def edit
    @event = current_ngo.events.includes(shifts: [:users]).find(params[:id])
  end

  def update
    if find_ngo_event.update(event_params)
      flash[:notice] = t('ngos.events.messages.update_success')
      redirect_to [:ngos, @event]
    else
      render :edit
    end
  end

  def destroy
    find_ngo_event.destroy
    redirect_to action: :index
  end

  def publish
    if find_ngo_event.publish!
      flash[:notice] = t('ngos.events.messages.publish_success')
    else
      flash[:notice] = t('ngos.events.messages.publish_fail')
    end
    redirect_to [:ngos, @event]
  end

  def cal
    cal = IcalFile.call item: find_ngo_event, attendee: current_ngo
    respond_to do |format|
      format.ics { send_data(cal,
        filename: 'ical.ics',
        disposition: 'inline; filename=ical.ics',
        type: 'text/calendar') }
    end
  end

  private

  def filter_params
    [
      (params[:filter_by].present? && params[:filter_by].to_sym) || nil,
      (params[:order_by].present? && params[:order_by].to_sym) || nil
    ]
  end

  def event_params
    params.require(:event).permit(
      :title, :description, :address, :lat, :lng,
      shifts_attributes: [:id, :volunteers_needed, :starts_at, :ends_at, :_destroy]
    )
  end

  def find_ngo_event
    @event = current_ngo.events.find params[:id]
  end
end
