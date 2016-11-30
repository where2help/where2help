class OngoingEventOperation
  class Index < Operation
    def setup_model!(params)
      ngo    = params.fetch(:current_ngo)
      order  = params.fetch(:order_by) { "created" }
      @model = sort_events(ngo.ongoing_events, order)
    end

    private

    def sort_events(events, order_by)
      case order_by
      when "address"
        events.order(:address)
      when "title"
        events.order(:title)
      else
        events.order(created_at: :desc)
      end
    end
  end

  class Show < Operation
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
      @model.update_attributes(event_params)
    end
  end

  class Destroy < Operation
    def process(params)
      ngo   = params.fetch(:current_ngo)
      event = ngo.ongoing_events.find(params[:event_id])
      event.destroy
      @model = event
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
end
