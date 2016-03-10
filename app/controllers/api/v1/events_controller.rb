class Api::V1::EventsController < Api::V1::ApiController
  skip_before_action :api_authenticate
  
  # wget --header="Authorization: Token token=scWTF92WXNiH2WhsjueJk4dN" -S http://localhost:3000/api/v1/events/
  def index
    @events = Event.where("starts_at > ?", Time.now).where.not(volunteers_needed: 0)
  end

  def show
    @event = Event.find(params[:id])
  end
end
