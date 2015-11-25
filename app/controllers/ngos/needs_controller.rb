class Ngos::NeedsController < NeedsController
  before_action :only_ngo_admin, except: [:show, :index]

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

end
