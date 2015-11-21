class Admin::NeedsController < NeedsController
  append_before_action :authenticate_user!
  before_action :only_admin

  def index
    @needs = Need.all
  end

  private

  def need_params
    params
      .require(:need)
      .permit(:location,
              :city,
              :start_time,
              :end_time,
              :category,
              :description,
              :volunteers_needed,
              :user_id)
  end
end
