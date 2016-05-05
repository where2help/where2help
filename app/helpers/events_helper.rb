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
end
