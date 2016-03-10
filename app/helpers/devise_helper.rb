module DeviseHelper
  def devise_error_messages!
    unless resource.errors.empty?
      content_tag(:div, class: 'alert alert-error alert-danger') do
        resource.errors.full_messages.each do |message|
          concat content_tag :li, message
        end
      end
    end
  end
end
