class VolunteeringsController < ApplicationController
  before_action :view_is_list?

  def create
    @need = Need.find(params[:need_id])
    @need.volunteerings.create(user: current_user)
  end

  def destroy
    volunteering = Volunteering.find(params[:id])
    @need = volunteering.need
    volunteering.destroy
    @need.reload
  end

  def view_is_list?
    @view_is_list = params[:list] == 'true'
  end

end
