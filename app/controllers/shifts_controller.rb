class ShiftsController < ApplicationController
  before_action :authenticate_user!

  def index
    @shifts = Shift.order(:starts_at)
  end
end
