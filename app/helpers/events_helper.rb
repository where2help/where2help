module EventsHelper
  def load_more_events_btn(events, params={})
    link_to_next_page events, t('events.load_more'),
      params: params,
      remote: true,
      data: { disable_with: "<i class='fa fa-spinner fa-spin'></i>", behavior: 'events-pagination' },
      class: 'btn'
  end

  def badge_for_event(event, user)
    'badge-info' if event.user_opted_in?(user)
  end

  def format_description(description)
    simple_format(auto_link description)
  end

  def label_for_event_state(event)
    state = t "activerecord.attributes.event.state/" + event.aasm.current_state.to_s
    state_class = event.pending? ? 'label' : 'label label-success'
    content_tag(:span, state, class: state_class)
  end

  def time_for_event(event)
    "#{event.shifts.first.starts_at.to_s(:time)} - #{event.shifts.last.ends_at.to_s(:time)}"    
  end
end
