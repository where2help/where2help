require 'rails_helper'

RSpec.describe NeedsController, type: :routing do

  describe 'routes' do

    it 'routes GET /needs to needs#index' do
      expect(get: 'needs').to route_to(
        controller: 'needs',
        action: 'index')
    end

    it 'routes GET /needs/:id to needs#show' do
      expect(get: 'needs/:id').to route_to(
        controller: 'needs',
        action: 'show',
        id: ':id')
    end
  end

  describe 'named routes' do

    it 'routes GET needs_path to needs#index' do
      expect(get: needs_path ).to route_to(
        controller: 'needs',
        action: 'index',
        locale: 'de')
    end

    it 'routes GET need_path(id) to needs#show' do
      expect(get: need_path('id')).to route_to(
        controller: 'needs',
        action: 'show',
        id: 'id',
        locale: 'de')
    end
  end
end
