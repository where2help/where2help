class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home
    redirect_to after_sign_in_path_for(current_user) if user_signed_in?
  end
  
  def calendar
  end

end
