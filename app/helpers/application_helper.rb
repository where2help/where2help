module ApplicationHelper
  BOOTSTRAP_FLASH_TYPES = {
    success: 'alert-success',
    error: 'alert-error',
    alert: 'alert-warning',
    notice: 'alert-info',
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

  def active_class(controller_names)
    Array(controller_names).include?(controller_name.sub("_controller", "")) ? "active" : ""
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

  def landing_page?
    controller.is_a?(PagesController) && params[:action] == "home"
  end

  def environment_disclaimer
    content_tag(:div, class: "alert #{bootstrap_class_for(:alert)} fade in") do
      content_tag(:p, t("application.environment_disclaimer"))
    end
  end

  def render_markdown(raw_markdown)
    Kramdown::Document.new(raw_markdown).to_html.html_safe
  end
end
