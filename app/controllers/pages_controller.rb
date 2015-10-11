class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    if user_signed_in? && current_user.admin?
      redirect_to pages_calendar_path
    else
      redirect_to needs_feed_path
    end
  end

  def calendar
  end

end
