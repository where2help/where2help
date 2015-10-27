class Volunteers::NeedsController < ApplicationController

  def index
    @needs = current_user.appointments.upcoming
  end
end
