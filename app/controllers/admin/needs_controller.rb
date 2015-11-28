class Admin::NeedsController < NeedsController
  # authenticate_user! has to be added again for index action
  append_before_action :authenticate_user!, only: [:index, :show]
  before_action :only_admin

  def index
    @needs = Need.all.page(params[:page])
  end
end
