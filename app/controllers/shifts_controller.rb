class ShiftsController < ApplicationController
  before_action :authenticate_user!

  def show
    @shift = Shift.includes(:event).
      where.not(events: { published_at: nil }).
      find(params[:id])
  end

  def opt_in
    find_shift.users << current_user
  rescue ActiveRecord::RecordInvalid => e
    redirect_to @shift.event
  end

  def opt_out
    current_user.shifts.try(:delete, find_shift)
    redirect_to schedule_path, notice: t('.notice')
  end

  def schedule
    scope = params[:filter].try(:to_sym)
    @shifts = current_user.shifts.filter(scope).page(params[:page])
  end

  def cal
    cal = IcalFile.call item: find_shift, attendee: current_user
    respond_to do |format|
      format.ics { send_data(cal,
        filename: 'ical.ics',
        disposition: 'inline; filename=ical.ics',
        type: 'text/calendar') }
    end
  end

  private

  def find_shift
    @shift = Shift.find params[:shift_id]
  end
end
