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

  def active?(path)
    path = path.split('?').first if path.is_a? String
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
