class Admin::NeedsController < NeedsController
  # authenticate_user! has to be added again for index action
  prepend_before_action :authenticate_user!
  prepend_before_action :only_admin

  def index
    @needs = Need.all.page(params[:page])
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def need_params
    params.
    require(:need).
    permit(:location,
            :city,
            :start_time,
            :end_time,
            :category,
            :description,
            :volunteers_needed,
            :user_id)
  end
end
