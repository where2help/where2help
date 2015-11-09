require 'rails_helper'

RSpec.describe Ngos::NeedsController, type: :routing do

  describe 'routes' do

    it 'routes GET /ngos/needs/calendar to ngos/needs#calendar' do
      expect(get: '/ngos/needs/calendar').to route_to(
        controller: 'ngos/needs',
        action: 'calendar')
    end

    it 'routes GET /ngos/needs/:id/edit to ngos/needs#edit' do
      expect(get: '//ngos/needs/:id/edit').to route_to(
        controller: 'ngos/needs',
        action: 'edit',
        id: ':id')
    end
  end

  describe 'named routes' do

    it 'routes GET calendar_ngos_needs to ngos/needs#calendar' do
      expect(get: calendar_ngos_needs_path).to route_to(
        controller: 'ngos/needs',
        action: 'calendar',
        locale: 'de')
    end

    it 'routes GET edit_ngos_need_path(:id) to ngos/needs#edit' do
      expect(get: edit_ngos_need_path(':id')).to route_to(
        controller: 'ngos/needs',
        action: 'edit',
        id: ':id',
        locale: 'de')
    end
  end
end
