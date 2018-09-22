class StatisticOperation
  class EventCount
    class Show
      def call(_params = {})
        Event.count
      end
    end
  end

  class TotalParticipants
    class Upcoming
      def call(_params = {})
        Shift.upcoming.sum(:volunteers_count)
      end
    end
    class Past
      def call(_params = {})
        Shift.past.sum(:volunteers_count)
      end
    end
  end

  class RequiredVolunteers
    class Show
      def call(_params = {})
        Shift.upcoming.sum(:volunteers_needed)
      end
    end
  end

  class VolunteerWorkHours
    class Show
      def call(_params = {})
        seconds = 0
        Shift.past.find_each do |shift|
          v_count = shift.volunteers_count
          next if v_count == 0

          duration_s = shift.ends_at - shift.starts_at
          seconds += (duration_s * v_count)
        end
        sprintf("%0.2f #{I18n.t 'time.hrs'}", seconds.to_f / (60 * 60))
      end
    end
  end
end
