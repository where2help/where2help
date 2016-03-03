module ApplicationHelper
  def navigation_for(visitor)
    if visitor
      visitor_type = visitor.class.name.demodulize.underscore.pluralize
      render "#{visitor_type}/nav"
    else
      render 'nav'
    end
  end
end
