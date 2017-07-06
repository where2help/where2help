require "ongoing_event/progress_bar_helper"

class OngoingEventOperation
  class Index < Operation
    include ProgressBarHelper

    def setup_model!(params)
      ngo    = params.fetch(:current_ngo)
      @model = ngo.ongoing_events.order(created_at: :desc)
    end
  end

  class Show < Operation
    include ProgressBarHelper

    def setup_model!(params)
      ngo    = params.fetch(:current_ngo)
      @model = ngo.ongoing_events.find(params[:event_id])
    end
  end

  class Create < Operation
    def setup_model!(params)
      ngo    = params.fetch(:current_ngo)
      @model = ngo.ongoing_events.new
    end

    def process(params)
      ngo          = params.fetch(:current_ngo)
      event_params = params.fetch(:ongoing_event)
      @model = ngo.ongoing_events.create(event_params)
    end
  end

  class Update < Operation
    def setup_model!(params)
      ngo    = params.fetch(:current_ngo)
      @model = ngo.ongoing_events.find(params[:event_id])
    end

    def process(params)
      ngo          = params.fetch(:current_ngo)
      event_params = params.fetch(:ongoing_event)
      @model       = ngo.ongoing_events.find(params[:event_id])
      handle_user_notification!(params, @model)
      @model.update_attributes(event_params)
    end

    private

    def handle_user_notification!(params, event)
      should_notify = params[:notify_users]
      if should_notify
        event.users.each do |user|
          UserMailer
            .ongoing_event_updated(user: user, event: event)
            .deliver_later
        end
      end
    end
  end

  class Destroy < Operation
    def process(params)
      ngo   = params.fetch(:current_ngo)
      event = ngo.ongoing_events.find(params[:event_id])
      notify_users!(event, event.users)
      event.destroy
      @model = event
    end

    private

    def notify_users!(event, users)
      users.each do |user|
        UserMailer
          .ongoing_event_destroyed(event: event, user: user)
          .deliver_later
      end
    end
  end

  class Publish < Operation
    def process(params)
      ngo   = params.fetch(:current_ngo)
      event = ngo.ongoing_events.find(params[:event_id])
      event.toggle_published!
      @model = event
    end
  end

  class Renew < Operation
    def process(params)
      ngo   = params.fetch(:current_ngo)
      event = ngo.ongoing_events.find_by(token: params[:token])
      event.renew!
      @model = event
    end
  end
end
