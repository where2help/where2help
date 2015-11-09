class Volunteers::NeedsController < ApplicationController
  
  def index
    @needs = current_user.appointments.
                          filter_scope(params[:scope] || 'upcoming').
                          filter_place(params[:place]).
                          page(params[:page]).per(10)
  end
end
