class EventsController < ApplicationController
  before_action :authenticate_user!

  def show
    @event = Event.published.find(params[:id])

    if Event::Block.blocked_non_participant?(user_id: current_user.id, event: @event)
      render file: "#{Rails.root}/public/404.html", layout: false, status: 404
      return
    end
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
end
