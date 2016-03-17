module ApplicationHelper
  BOOTSTRAP_FLASH_TYPES = {
    success: 'alert-success',
    error: 'alert-error',
    alert: 'alert-warning',
    notice: 'alert-info'
  }

  def navigation_for(visitor)
    if visitor
      visitor_type = visitor.class.name.demodulize.underscore.pluralize
      render "#{visitor_type}/nav"
    else
      render 'nav'
    end
  end

  def format_shift(shift)
    "#{format_volunteers_needed(shift.volunteers_needed)} — #{format_datetimes(shift.starts_at, shift.ends_at)} (#{shift.volunteers_count}/#{shift.volunteers_needed} volunteering)"
  end

  def format_volunteers_needed(volunteers_needed)
    "#{volunteers_needed} volunteer#{volunteers_needed == 1 ? '' : 's'} needed"
  end

  def format_datetimes(starts_at, ends_at)
    start_datetime = starts_at.strftime("%d. %b. %H:%M")
    end_time = ends_at.strftime("%H:%M")
    "#{start_datetime} - #{end_time}"
  end

  def active?(path)
    current_page?(path) ? 'active' : ''
  end

  def bootstrap_class_for(flash_type)
    BOOTSTRAP_FLASH_TYPES[flash_type.to_sym]
  end

  def flash_messages
    flash.each do |flash_type, message|
      concat(content_tag(:div, class: "alert #{bootstrap_class_for(flash_type)} fade in") do
        concat content_tag(:button, 'x', class: "close", data: { dismiss: 'alert' })
        concat message
      end)
    end
    nil
  end
end
