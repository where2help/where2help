module VolunteeringsHelper

  def volunteerings_button(need)
    volunteering = need.volunteerings.find_by_user_id(current_user)
    case
    when !need.upcoming?
      t(:thanks, scope: [:helpers, :volunteerings])
    when volunteering
      [
        volunteerings_destroy_info(need),
        volunteerings_destroy_button(volunteering)
      ].join.html_safe
    else
      [
        volunteerings_create_info(need),
        volunteerings_create_button(need)
      ].join.html_safe
    end
  end

  def volunteerings_create_button(need)
    link_to t(:help, scope: [:helpers, :volunteerings]), volunteerings_path(need_id: need),
              method: :post,
              remote: true,
              data: { disable_with: "<i class='fa fa-spinner fa-spin'></i>" },
              class:  'btn btn-default btn-block btn-volunteering -create'
  end

  def volunteerings_destroy_button(volunteering)
    link_to t(:cancel, scope: [:helpers, :volunteerings]), volunteering_path(volunteering),
              method: :delete,
              remote: true,
              data: {
                confirm: t(:confirm, scope: [:helpers, :volunteerings]),
                disable_with: "<i class='fa fa-spinner fa-spin'></i>"
              },
              class:  'btn btn-default btn-block btn-volunteering -destroy'
  end

  def volunteerings_create_info(need)
    num_needed = [0, need.volunteers_needed - need.volunteerings_count].max
    content_tag :p do
      t(:info_create_html, num: num_needed, scope: [:helpers, :volunteerings])
    end
  end

  def volunteerings_destroy_info(need)
    come_at = I18n.localize(need.start_time, format:'%H:%M')
    content_tag :p do
      t(:info_destroy_html, time: come_at, scope: [:helpers, :volunteerings])
    end
  end
end
