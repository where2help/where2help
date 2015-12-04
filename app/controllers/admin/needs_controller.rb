class Admin::NeedsController < NeedsController
  # authenticate_user! has to be added again for index action
  prepend_before_action :authenticate_user!
  before_action :only_admin

  def index
    @needs = Need.all.page(params[:page])
  end
end
