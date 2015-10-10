class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    if current_user.admin?
      redirect_to pages_calendar_path
    else
      # TODO: Max, input your route
      # no route yet ;)
      @needs = Need.all
    end
  end

  def calendar
  end

end
