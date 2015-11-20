require 'rails_helper'

RSpec.describe Admin::NeedsController, type: :routing do
  describe 'routes' do
    it 'routes GET /admin/needs/ to admin/needs' do
      expect(get: '//admin/needs/').to route_to(
        controller: 'admin/needs',
        action: 'index')
    end
  end

  describe 'named routes' do
    it 'routes GET admin_needs_path to admin/needs' do
      expect(get: admin_needs_path).to route_to(
        controller: 'admin/needs',
        action: 'index',
        locale: 'de')
    end
  end
end
