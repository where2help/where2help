class OngoingEventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events =
      OngoingEventOperation::User::Index.present().model.page(params[:page])
  end

  def show
    @event = OngoingEventOperation::User::Show.present(event_id: params[:id]).model
  end
end

