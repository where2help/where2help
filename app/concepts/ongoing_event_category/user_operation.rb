require "ongoing_event_category/progress_bar_helper"

class OngoingEventCategoryOperation
  class User
    class Index < Operation
      include ProgressBarHelper

      def setup_model!(params)
        @model = OngoingEventCategory
                   .joins(:ongoing_events)
                   .merge(OngoingEvent.published)
                   .distinct
                   .ordered
      end
    end
  end
end
