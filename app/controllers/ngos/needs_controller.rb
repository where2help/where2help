class Ngos::NeedsController < NeedsController
  before_action :only_ngo_admin, except: [:show, :index]

  def calendar
  end
end
