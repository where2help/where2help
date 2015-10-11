module NeedsHelper

  def icon_for(need)
    image_tag("needs/#{need.category}.png", class: 'img-responsive')
  end

  def view_more_link(resource)
    link_to_next_page resource, 'Mehr anzeigen',
      remote: true,
      data: { disable_with: "<i class='fa fa-spinner fa-spin'></i>" },
      class: 'btn btn-primary btn-lg btn-block view-more'
  end

  def volunteerings_button(need)
    button_options = _button_options(need)
    button_to button_options[:url],
              method: button_options[:method],
              remote: true,
              data: { disable_with: "<i class='fa fa-spinner fa-spin'></i>" },
              class:  button_options[:btn_class] do
      content_tag(:i, nil, class: button_options[:icon]) + ' ' + button_options[:txt]
    end
  end

  private

  def _button_options(need)
    volunteering = need.volunteerings.find_by_user_id(current_user)
    open = need.volunteerings.count < need.volunteers_needed
    { url: volunteering ? volunteering_path(volunteering) : volunteerings_path(need_id: need.id),
      txt: volunteering ? 'Absagen' : 'Helfen',
      icon: volunteering ? 'fa fa-times' : 'fa fa-check',
      method: volunteering ? :delete : :post,
      btn_class: volunteering ? 'btn btn-danger btn-lg btn-block' : "btn btn-#{open ? 'success' : 'warning'} btn-lg btn-block"
    }
    
  end
end
