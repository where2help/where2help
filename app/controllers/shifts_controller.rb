class ShiftsController < ApplicationController
  before_action :authenticate_user!

  def index
    @shifts = Shift.joins(:event).
      where(events: {state: 'published'}).
      where('volunteers_needed > volunteers_count').
      where('starts_at > NOW()').
      order(:starts_at).
      page(params[:page])
  end

  def show
    @shift = Shift.includes(:event).find params[:id]
  end

  def opt_in
    set_shift
    @shift.users << current_user
  rescue ActiveRecord::RecordInvalid => e
    redirect_to @shift.event, alert: e.message
  end

  def opt_out
    set_shift
    @shift.shifts_users.find_by_user_id(current_user).try(:destroy)
    redirect_to schedule_path, notice: t('.notice')
  end

  def schedule
    case params[:filter].try(:to_sym)
    when :past
      @shifts = current_user.shifts.where('starts_at < NOW()').order(:starts_at).page(params[:page]).per(10)
    when :all
      @shifts = current_user.shifts.order(:starts_at).page(params[:page]).per(10)
    else
      @shifts = current_user.shifts.where('starts_at > NOW()').order(:starts_at).page(params[:page]).per(10)
    end
  end

  def cal
    set_shift
    cal = RiCal.Calendar do |cal|
      cal.event do |event|
        event.summary      = @shift.event.title
        event.description  = @shift.event.description
        event.dtstart      = @shift.starts_at
        event.dtend        = @shift.ends_at
        event.location     = @shift.event.address
        event.url          = shift_url(@shift)
        event.add_attendee current_user.email
        event.alarm do |alarm|
          alarm.description = @shift.event.title
        end
      end
    end
    respond_to do |format|
      format.ics { send_data(cal.export, :filename=>"cal.ics", :disposition=>"inline; filename=cal.ics", :type=>"text/calendar")}
    end
  end

  private

  def set_shift
    @shift = Shift.find params[:shift_id]
  end
end
