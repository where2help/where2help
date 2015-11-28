class VolunteeringsController < ApplicationController

  def create
    respond_to do |format|
      @need = Need.find(params[:need_id])
      @need.volunteerings.create(user: current_user)
      format.html { redirect_to @need }
      format.js
    end
  end

  def destroy
    respond_to do |format|
      volunteering = Volunteering.find(params[:id])
      @need = volunteering.need
      volunteering.destroy
      @need.reload
      format.html { redirect_to @need }
      format.js
    end
  end
end
