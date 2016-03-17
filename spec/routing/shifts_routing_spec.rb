require 'rails_helper'

RSpec.describe ShiftsController, type: :routing do
  describe 'routes ' do
    it 'routes GET /shifts to #index' do
      expect(get: '/shifts').to route_to 'shifts#index'
    end
  end
  describe 'named routes' do
    it 'routes GET shifts_path to #index' do
      expect(get: shifts_path).to route_to 'shifts#index'
    end
  end
end
