class Notification::Utils
  class << self
    def pretty_date(time, locale)
      I18n.localize(time, format: "%A, %d %b %Y", locale: locale)
    end

    def pretty_time(time, locale)
      I18n.localize(time, format: "%H:%M", locale: locale)
    end
  end
end
