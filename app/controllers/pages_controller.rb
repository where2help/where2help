class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    @needs = Need.all
  end

  def calendar
  end
  
end
