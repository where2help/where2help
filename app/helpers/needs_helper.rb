module NeedsHelper

  def icon_for(need)
    image_tag("needs/#{need.category}.png", height: '64', class: 'media-object')
  end

  def view_more_link(resource, opt_1=:category, opt_2=:place)
    link_to_next_page resource, 'Mehr anzeigen',
      remote: true,
      data: { disable_with: "<i class='fa fa-spinner fa-spin'></i>" },
      params: { opt_1 => params[opt_1], opt_2 => params[opt_2] },
      class: 'btn btn-primary btn-lg btn-block view-more'
  end

  def short_date_for_need(need)
    case need.start_time.to_date
    when Date.today
      t(:today)
    when Date.tomorrow
      t(:tomorrow)
    else
      I18n.localize(need.start_time, format:'%a %d.%m')
    end
  end
end
