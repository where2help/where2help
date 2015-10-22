class NeedsController < ApplicationController
  before_action :set_need, only: [:edit, :update, :destroy]
  before_action :only_ngo_admin, except: [:show, :index, :feed]
  respond_to :html

  def feed
    @needs = Need.includes(:volunteerings).
                  upcoming.
                  unfulfilled.
                  page(params[:page]).per(20)
  end

  # GET /needs
  # GET /needs.json
  def index
    @needs = Need.all
  end

  # GET /needs/1
  # GET /needs/1.json
  def show
    @need = Need.find(params[:id])
  end

  # GET /needs/new
  def new
    @need = Need.new
  end

  # GET /needs/1/edit
  def edit
  end

  # POST /needs
  # POST /needs.json
  def create
    @need = Need.new(need_params)

    respond_to do |format|
      if @need.save
        format.html { redirect_to @need, notice: 'Need was successfully created.' }
        format.json { render :show, status: :created, location: @need }
      else
        format.html { render :new }
        format.json { render json: @need.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /needs/1
  # PATCH/PUT /needs/1.json
  def update
    respond_to do |format|
      if @need.update(need_params)
        # Add lat and lng to need
        Workers::Coords.new.async.perform(@need.id)
        format.html { redirect_to root_path, notice: 'Need was successfully updated.' }
        format.json { render :show, status: :ok, location: @need }
      else
        format.html { render :edit }
        format.json { render json: @need.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /needs/1
  # DELETE /needs/1.json
  def destroy
    @need.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Need was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_need
      if current_user && current_user.admin?
        @need = Need.find(params[:id])
      else
        @need = Need.where(id: params[:id], user_id: current_user.id)
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def need_params
      params.
      require(:need).
      permit(:location,
              :city,
              :start_time,
              :end_time,
              :category,
              :volunteers_needed,
              :user_id).
      merge(user_id: current_user.id)
    end
end
