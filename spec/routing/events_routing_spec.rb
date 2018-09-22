# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :routing do
  describe 'routes ' do
    it 'routes GET events to #index' do
      expect(get: 'events').to route_to 'events#index'
    end

    it 'routes GET events/:id to #show' do
      expect(get: 'events/1').to route_to 'events#show', id: '1'
    end
  end
  describe 'named routes' do
    it 'routes GET events_path to #index' do
      expect(get: events_path).to route_to 'events#index'
    end

    it 'routes GET event_path to #show' do
      expect(get: event_path('1')).to route_to 'events#show', id: '1'
    end
  end
end
