class Ngos::OngoingEventsController < ApplicationController
  before_action :authenticate_ngo!

  def index
    @events = OngoingEventOperation::Index.present(current_ngo: current_ngo)
  end

  def show
    @event = OngoingEventOperation::Show.present(current_ngo: current_ngo, event_id: params[:id])
  end

  def new
    @event = OngoingEventOperation::Create.present(current_ngo: current_ngo).model
  end

  def create
    @event = OngoingEventOperation::Create.(current_ngo: current_ngo, event: params[:event]).model
    if @event.valid?
      return redirect_to ngos_ongoing_events_url,
        notice: t("ngos.ongoing_events.messages.create_success")
    end
    render :new
  end

  def edit
    @event = OngoingEventOperation::Update.present(current_ngo: current_ngo, event_id: params[:id]).model
  end

  def update
    @event = OngoingEventOperation::Update.(current_ngo: current_ngo, event: params[:event]).model
    if @event.valid?
      return redirect_to ngos_ongoing_events_url,
        notice: t("ngos.ongoing_events.messages.update_success")
    end
    render :edit
  end

  def destroy
    @event = OngoingEventOperation::Destroy.(current_ngo: current_ngo, event_id: params[:id]).model
    return redirect_to ngos_ongoing_events_url,
      notice: t("ngos.ongoing_events.messages.delete_success")
  end
end
