class Ngos::NeedsController < NeedsController
  before_action :only_ngo_admin

  def calendar
  end
end
