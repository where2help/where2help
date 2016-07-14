require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "GET /events" do
    it 'returns the events' do
      ngo = create :ngo
      event = create :event, :with_shift, state: :published,
                                          ngo: ngo
      get "/api/v1/events", as: :json, headers: token_header

      expect(response).to be_success
      expect(json).to include_json([{"id" => event.id,
                                     "title" => event.title,
                                     "description" => event.description,
                                      "address" => event.address,
                                      "lat" => event.lat,
                                      "lng" => event.lng,
                                      "state" => event.state,
                                      "organization_name" => event.ngo.name,
                                      "shifts" =>
                                       [{"id" => event.shifts.first.id,
                                         "event_id" => event.id,
                                         "starts_at"=> event.shifts.first.starts_at.strftime("%FT%T.%L%:z"),
                                         "ends_at" => event.shifts.first.ends_at.strftime("%FT%T.%L%:z"),
                                         "volunteers_needed" => event.shifts.first.volunteers_needed,
                                         "volunteers_count" => event.shifts.first.volunteers_count,
                                         "current_user_assigned" => false
                                      }] 
                                    }])
    end
  end  
end
