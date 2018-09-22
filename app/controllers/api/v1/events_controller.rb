# frozen_string_literal: true

class Api::V1::EventsController < Api::V1::ApiController
  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" -S http://localhost:3000/api/v1/events/
  def index
    @events = Event.published.where(id: Shift.not_full.pluck(:event_id)).includes(:ngo).includes(shifts: [:users])
    if params[:upcoming]
      @events = @events.select{ |event| event.ends_at && event.ends_at > Time.now }
    end

    if params[:minimal]
      render(:minimal_index) && return
    end
  end

  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" -S http://localhost:3000/api/v1/events/1
  def show
    @event = Event.find(params[:id])
    if params[:minimal]
      render(:minimal_show) && return
    end
  end
end
