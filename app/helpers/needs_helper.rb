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

  def volunteerings_button(need)
    button_options = _button_options(need)
    button_to button_options[:url],
              method: button_options[:method],
              remote: true,
              data: { disable_with: "<i class='fa fa-spinner fa-spin'></i>" },
              class:  "btn btn-default btn-block btn-volunteering #{button_options[:class] if button_options[:class]}" do
      render 'volunteerings/button', need: need, txt: button_options[:txt], action: button_options[:action]
    end
  end

  private

  def _button_options(need)
    volunteering = need.volunteerings.find_by_user_id(current_user)
    #open = need.volunteerings.count < need.volunteers_needed
    { url: volunteering ? volunteering_path(volunteering) : volunteerings_path(need_id: need.id),
      txt: volunteering ? "Bitte komm um #{I18n.localize(need.start_time, format:'%H:%M')}" : "Wir brauchen noch #{[0, need.volunteers_needed - need.volunteerings_count].max} Helfer",
      action: volunteering ? 'Absagen' : 'Helfen',
      #icon: volunteering ? 'fa fa-times' : 'fa fa-check',
      method: volunteering ? :delete : :post,
      class: volunteering ? 'btn-active' : nil
    }

  end
end
