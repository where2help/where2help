class OngoingEventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events =
      OngoingEventOperation::User::Index.present().model.page(params[:page])
  end

  def show
    @event = OngoingEventOperation::User::Show.present(event_id: params[:id]).model
  end

  def opt_in
    @event = OngoingEventOperation::User::OptIn
      .(current_user: current_user, event_id: params[:id])
      .model
  end

  def opt_out
    @event = OngoingEventOperation::User::OptOut
      .(current_user: current_user, event_id: params[:id])
      .model
    redirect_to ongoing_event_path(@event)
  end
end

