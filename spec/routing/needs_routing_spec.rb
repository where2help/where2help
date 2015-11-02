require 'rails_helper'

RSpec.describe NeedsController, type: :routing do

  describe 'routes' do

    it 'routes GET /needs to needs#index' do
      expect(get: 'needs').to route_to(
        controller: 'needs',
        action: 'index')
    end

    it 'routes GET /needs/list to needs#list' do
      expect(get: 'needs/list').to route_to(
        controller: 'needs',
        action: 'list')
    end
  end

  describe 'named routes' do

    it 'routes GET needs_path to needs#index' do
      expect(get: needs_path ).to route_to(
        controller: 'needs',
        action: 'index',
        locale: 'de')
    end

    it 'routes GET list_needs_path to needs#list' do
      expect(get: list_needs_path).to route_to(
        controller: 'needs',
        action: 'list',
        locale: 'de')
    end
  end
end
