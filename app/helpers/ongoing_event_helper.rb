module OngoingEventHelper
  def ongoing_event_opt_in_button_for(event)
    opted_in = event.users.include?(current_user)
    if opted_in
      path   = opt_out_ongoing_event_path(event)
      color  = "danger"
      method = :delete
      icon   = "close"
      text   = t("shifts.opt_out_btn")
      data   = { confirm: t('shifts.are_you_sure') }
    else
      path   = opt_in_ongoing_event_path(event)
      color  = "success"
      method = :post
      icon   = "thumbs-o-up"
      text   = t("shifts.opt_in_btn")
      data   = {}
    end

    link_to path,
      class: "btn btn-#{color} event-btn",
      method: method,
      data: data.merge(disable_with: "<i class='fas fa-spinner fa-spin'></i>") do
      content_tag(:i, nil, class: "fas fa-#{icon}") + " " + text
    end
  end
end
