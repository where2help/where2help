class Ngos::NeedsController < NeedsController
  before_action :authenticate_user!, only: [:show, :index]
  before_action :only_ngo_admin

  def calendar
  end

  # PATCH/PUT /needs/1
  # PATCH/PUT /needs/1.json
  def update
    respond_to do |format|
      if @need.update(need_params)
        # Add lat and lng to need
        Workers::Coords.new.async.perform(@need.id)
        format.html { redirect_to @need, notice: 'Need was successfully updated.' }
        format.json { render :show, status: :ok, location: @need }
      else
        format.html { render :edit }
        format.json { render json: @need.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @need = Need.find_by(id: params[:id], user_id: current_user.id)
  end

  def index
    ngo_admin_ids = User.where(organization: current_user.organization).pluck(:id)
    @needs = Need.where(user_id: ngo_admin_ids).page(params[:page])
  end
end