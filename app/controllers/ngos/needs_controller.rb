class Ngos::NeedsController < NeedsController

  def calendar
  end

  def edit
    @need = Need.find(params[:id])
  end
end
