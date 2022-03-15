class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_event, only: [:show]
  before_action :redirect_blocked_unless_participating, only: [:show]

  def show
  end

  def index
    list = Event::List.(
      filter: params[:filter],
      page: params[:page],
      last_date: params[:last_date],
      user: current_user,
    )

    @events = list.events
    @last_event_date = list.last_event_date
  end

  private

  def load_event
    @event = Event.published.find(params[:id])
  end

  def redirect_blocked_unless_participating
    if Event::Block.blocked_non_participant?(user_id: current_user.id, event: @event)
      redirect_to events_url, notice: t(".not_exist")
    end
  end
end
