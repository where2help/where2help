class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    redirect_to list_needs_path if user_signed_in?
  end

  def calendar
  end

end
