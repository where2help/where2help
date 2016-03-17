class ShiftsController < ApplicationController

  def index
    @shifts = Shift.order(:starts_at)
  end
end
