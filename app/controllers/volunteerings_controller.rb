class VolunteeringsController < ApplicationController

  def create
    @need = Need.find(params[:need_id])
    @need.volunteerings.create(user: current_user)
  end

  def destroy
    volunteering = Volunteering.find(params[:id])
    @need = volunteering.need
    volunteering.destroy
  end
end
