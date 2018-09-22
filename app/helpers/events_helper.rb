module EventsHelper
  def load_more_events_btn(events, params={})
    link_to_next_page events, t('events.load_more'),
      params: params,
      remote: true,
      data: { disable_with: "<i class='fas fa-spinner fa-spin'></i>", behavior: 'events-pagination' },
      class: 'btn'
  end

  def format_event_date_group(date)
    if date.today?
      "#{t("helpers.events_helper.today")}, #{l date.to_date}"
    elsif (date-1.day).today?
      "#{t("helpers.events_helper.tomorrow")}, #{l date.to_date}"
    else
      l date.to_date, format: :events_date_group
    end
  end

  def format_description(description)
    if description.blank?
      '-'
    else
      simple_format(auto_link description)
    end
  end

  def event_label(event)
    attrs = event_label_attr event
    state = t "activerecord.attributes.event.state/" + event.state
    content_tag(:div, class: 'ngo-event-item-state') do
      concat content_tag(:i, nil, class: "fas #{attrs[:icon_class]} fa-fw")
      concat content_tag(:span, attrs[:state], class: attrs[:label_class])
    end
  end

  def label_for_event_state(event)
    attrs = event_label_attr event
    if event.pending?
      state_class = 'label'
      icon_class = 'fa-eye-slash'
    else
      state_class = 'label label-info'
      icon_class = 'fa-eye'
    end
    state = t "activerecord.attributes.event.state/" + event.state
    concat content_tag(:i, nil, class: "fa-li fas #{icon_class} fa-fw")
    content_tag(:span, state, class: state_class)
  end

  def time_for_event(event)
    "#{event.shifts.first.starts_at.to_s(:time)} - #{event.shifts.last.ends_at.to_s(:time)}"
  end

  private

  def event_label_attr(event)
    attrs = {}
    if event.pending?
      attrs[:label_class] = 'label'
      attrs[:icon_class] = 'fa-eye-slash'
    else
      attrs[:label_class] = 'label label-info'
      attrs[:icon_class] = 'fa-eye'
    end
    attrs[:state] = t "activerecord.attributes.event.state/" + event.state
    attrs
  end
end
