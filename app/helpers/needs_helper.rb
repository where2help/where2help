module NeedsHelper

  def icon_for(need)
    image_tag("needs/#{need.category}.png", class: 'img-responsive')
  end

  def view_more_link(resource)
    link_to_next_page resource, 'Mehr anzeigen',
      remote: true,
      data: { disable_with: 'lädt...' },
      class: 'btn btn-primary view-more'
  end
end
