require "ongoing_event/operation"
class Ngos::OngoingEventsController < ApplicationController
  before_action :authenticate_ngo!
  skip_before_action :authenticate_ngo!, if: -> { authentication_skippable }

  def index
    @operation =
      OngoingEventOperation::Index.present(current_ngo: current_ngo)
    @events = @operation.model
  end

  def show
    current_ngo = current_ngo || Ngo.find_by_id(params[:ngo_id])
    sign_in current_ngo if params[:sign_in]
    @operation =
      OngoingEventOperation::Show.present(current_ngo: current_ngo, event_id: params[:id])
    @event = @operation.model
    @event.unpublish! if params[:unpublish]
  end

  def new
    @event =
      OngoingEventOperation::Create.present(current_ngo: current_ngo).model
  end

  def create
    @event = OngoingEventOperation::Create.(
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
      OngoingEventOperation::Update.(
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
      OngoingEventOperation::Destroy.(current_ngo: current_ngo, event_id: params[:id]).model
    return redirect_to ngos_ongoing_events_url,
      notice: t("ngos.ongoing_events.messages.delete_success")
  end

  def publish
    @event =
      OngoingEventOperation::Publish.(current_ngo: current_ngo, event_id: params[:id]).model
    return redirect_to ngos_ongoing_event_url(@event),
      notice: t("ngos.events.messages.#{@event.published? ? 'publish' : 'unpublish'}_success")
  end

  def renew
    current_ngo = current_ngo || Ngo.find_by_id(params[:ngo_id])
    @event = OngoingEventOperation::Renew.(current_ngo: current_ngo, token: params[:token], event_id: params[:id]).model
    if signed_in?
      redirect_to ngos_ongoing_event_url(@event),
        notice: t("ngos.events.messages.renew_success")
    else
      redirect_to new_ngo_session_path,
        notice: t("ngos.events.messages.renew_success")
    end
  end

  private

  def event_params(params)
    params.require(:ongoing_event).permit(
      :contact_person, :title, :description,
      :address, :approximate_address,:lat, :lng,
      :volunteers_needed, :ongoing_event_category_id,
      :start_date, :end_date, :token
    )
  end

  def authentication_skippable
    event = OngoingEvent.find_by_id(params[:ongoing_event_id] || params[:id])
    (action_name == "show" || action_name == "renew") && event && event.token == params[:token]
  end
end
