require "ongoing_event/operation"
class Ngos::OngoingEventsController < ApplicationController
  before_action :authenticate_ngo!

  def index
    @operation =
      OngoingEventOperation::Index.present(current_ngo: current_ngo)
    @events = @operation.model
  end

  def show
    @operation =
      OngoingEventOperation::Show.present(current_ngo: current_ngo, event_id: params[:id])
    @event = @operation.model
  end

  def new
    @event =
      OngoingEventOperation::Create.present(current_ngo: current_ngo).model
  end

  def create
    @event = OngoingEventOperation::Create.call(
      current_ngo: current_ngo,
      ongoing_event: event_params(params)
    ).model
    if @event.valid?
      return redirect_to ngos_ongoing_event_url(@event),
                         notice: t("ngos.ongoing_events.messages.create_success")
    end
    render :new
  end

  def edit
    @event =
      OngoingEventOperation::Update.present(current_ngo: current_ngo, event_id: params[:id]).model
  end

  def update
    @event =
      OngoingEventOperation::Update.call(
        current_ngo: current_ngo,
        event_id: params[:id],
        ongoing_event: event_params(params),
        notify_users: params[:notify_users]
      ).model
    if @event.valid?
      return redirect_to ngos_ongoing_event_url(@event),
                         notice: t("ngos.events.messages.update_success")
    end
    render :edit
  end

  def destroy
    @event =
      OngoingEventOperation::Destroy.call(current_ngo: current_ngo, event_id: params[:id]).model
    redirect_to ngos_ongoing_events_url,
                notice: t("ngos.ongoing_events.messages.delete_success")
  end

  def publish
    @event =
      OngoingEventOperation::Publish.call(current_ngo: current_ngo, event_id: params[:id]).model
    redirect_to ngos_ongoing_event_url(@event),
                notice: t("ngos.events.messages.#{@event.published? ? 'publish' : 'unpublish'}_success")
  end

  private

  def event_params(params)
    params.require(:ongoing_event).permit(
      :contact_person, :title, :description,
      :address, :approximate_address, :lat, :lng,
      :volunteers_needed, :ongoing_event_category_id,
      :start_date, :end_date
    )
  end
end
