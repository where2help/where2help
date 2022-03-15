require "event/operation"
require "event/block"

class Ngos::EventsController < ApplicationController
  before_action :authenticate_ngo!

  def index
    @shifts = Shift.filtered_for_ngo(current_ngo, filter_params)
  end

  def show
    find_ngo_event
  end

  def new
    @event = current_ngo.new_event
  end

  def create
    @event = current_ngo.events.new event_params
    if @event.save
      flash[:notice] = t("ngos.events.messages.create_success")
      redirect_to [:ngos, @event]
    else
      render :new
    end
  end

  def edit
    @operation = EventOperation::Ngo::Update.present(
      ngo: current_ngo,
      event_id: params[:id],
    )
    @event = @operation.model
  end

  def update
    @operation = EventOperation::Ngo::Update.call(
      ngo: current_ngo,
      event_id: params[:id],
      event: event_params,
      notify_users: params[:notify_users],
    )
    @event = @operation.model
    if @event.valid?
      flash[:notice] = t("ngos.events.messages.update_success")
      redirect_to [:ngos, @event]
    else
      render :edit
    end
  end

  def destroy
    find_ngo_event.destroy
    redirect_to action: :index
  end

  def toggle_block
    Event::Block.toggle(user_id: params[:user_id], ngo: current_ngo)

    find_ngo_event
    redirect_to [:ngos, @event]
  end

  def publish
    flash[:notice] = if find_ngo_event.publish!
        t("ngos.events.messages.publish_success")
      else
        t("ngos.events.messages.publish_fail")
      end
    redirect_to [:ngos, @event]
  end

  def cal
    cal = IcalFile.call item: find_ngo_event, attendee: current_ngo
    respond_to do |format|
      format.ics do
        send_data(cal,
                  filename: "ical.ics",
                  disposition: "inline; filename=ical.ics",
                  type: "text/calendar")
      end
    end
  end

  private

  def filter_params
    (params[:filter_by].present? && params[:filter_by].to_sym) || nil
  end

  def event_params
    params.require(:event).permit(
      :person, :title, :description, :address, :lat, :lng, :approximate_address,
      shifts_attributes: [:id, :volunteers_needed, :starts_at, :ends_at, :_destroy],
    )
  end

  def find_ngo_event
    @event = current_ngo.events.includes(shifts: [users: :blocks]).find(params[:id])
  end
end
