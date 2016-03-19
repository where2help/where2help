class ShiftsController < ApplicationController
  before_action :authenticate_user!

  def index
    @shifts = Shift.order(:starts_at)
  end

  def show
    @shift = Shift.includes(:event).find params[:id]
  end

  def opt_in
    set_shift
    @shift.users << current_user
  rescue ActiveRecord::RecordInvalid => e
    redirect_to @shift, alert: e.message
  end

  private

  def set_shift
    @shift = Shift.find params[:shift_id]
  end
end
