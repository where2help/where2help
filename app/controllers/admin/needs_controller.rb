class Admin::NeedsController < NeedsController
  append_before_action :authenticate_user!
  before_action :only_admin

  def index
    @needs = Need.all
  end
end
