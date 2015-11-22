class Admin::NeedsController < NeedsController
  # authenticate_user! has to be added again for index action
  append_before_action :authenticate_user!
  before_action :only_admin
  append_before_action :set_need, only: [:edit, :update, :destroy]

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
