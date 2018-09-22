# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Events", type: :request do
  describe "GET /events" do
    it 'returns the events' do
      ngo = create :ngo
      event = create :event, :with_shift, :published, ngo: ngo
      get "/api/v1/events", as: :json, headers: token_header

      expect(response).to be_successful
      expect(json).to include_json([{ "id" => event.id,
                                      "title" => event.title,
                                      "description" => event.description,
                                      "address" => event.address,
                                      "lat" => event.lat,
                                      "lng" => event.lng,
                                      "state" => event.state,
                                      "organization_name" => event.ngo.name,
                                      "shifts" =>
                                       [{ "id" => event.shifts.first.id,
                                          "event_id" => event.id,
                                          "starts_at" => event.shifts.first.starts_at.strftime("%FT%T.%L%:z"),
                                          "ends_at" => event.shifts.first.ends_at.strftime("%FT%T.%L%:z"),
                                          "volunteers_needed" => event.shifts.first.volunteers_needed,
                                          "volunteers_count" => event.shifts.first.volunteers_count,
                                          "current_user_assigned" => false }] }])
    end
  end

  describe "GET /events?minimal=true" do
    it 'returns the events with minimal json' do
      ngo = create :ngo
      event = create :event, :with_shift, :published, ngo: ngo
      get "/api/v1/events?minimal=true", as: :json, headers: token_header
      expect(response).to be_successful
      expect(json).to include_json([{ "id" => event.id,
                                      "shifts" =>
                                     [{ "id" => event.shifts.first.id,
                                        "volunteers_needed" => event.shifts.first.volunteers_needed,
                                        "volunteers_count" => event.shifts.first.volunteers_count,
                                        "current_user_assigned" => false }] }])
    end
  end

  describe "GET /events/:id" do
    it 'returns the event' do
      ngo = create :ngo
      event = create :event, :with_shift, :published, ngo: ngo
      get "/api/v1/events/" + event.id.to_s, as: :json, headers: token_header

      expect(response).to be_successful
      expect(json).to include_json( "id" => event.id,
                                    "title" => event.title,
                                    "description" => event.description,
                                    "address" => event.address,
                                    "lat" => event.lat,
                                    "lng" => event.lng,
                                    "person" => event.person,
                                    "state" => event.state,
                                    "organization_name" => event.ngo.name,
                                    "shifts" =>
                                    [{ "id" => event.shifts.first.id,
                                       "event_id" => event.id,
                                       "starts_at" => event.shifts.first.starts_at.strftime("%FT%T.%L%:z"),
                                       "ends_at" => event.shifts.first.ends_at.strftime("%FT%T.%L%:z"),
                                       "volunteers_needed" => event.shifts.first.volunteers_needed,
                                       "volunteers_count" => event.shifts.first.volunteers_count,
                                       "current_user_assigned" => false }] )
    end
  end

  describe "GET /events/:id?minimal=true" do
    it 'returns the event with minimal json' do
      ngo = create :ngo
      event = create :event, :with_shift, :published, ngo: ngo
      get "/api/v1/events/" + event.id.to_s + "?minimal=true", as: :json, headers: token_header
      expect(response).to be_successful
      expect(json).to include_json( "id" => event.id,
                                    "shifts" =>
                                    [{ "id" => event.shifts.first.id,
                                       "volunteers_needed" => event.shifts.first.volunteers_needed,
                                       "volunteers_count" => event.shifts.first.volunteers_count,
                                       "current_user_assigned" => false }] )
    end
  end
end
