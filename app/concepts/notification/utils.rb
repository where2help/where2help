class Notification::Utils
  class << self
    def pretty_date(time)
      time.strftime("%A, %d %b %Y")
    end

    def pretty_time(time)
      time.strftime("%H:%M")
    end
  end
end
