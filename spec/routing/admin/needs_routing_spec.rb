require 'rails_helper'

RSpec.describe Admin::NeedsController, type: :routing do
  describe 'routes' do
    it 'routes GET /admin/needs/ to admin/needs#index' do
      expect(get: '//admin/needs/').to route_to(
        controller: 'admin/needs',
        action: 'index')
    end

    it 'routes GET /admin/needs/:id to admin/needs#show' do
      expect(get: '//admin/needs/:id').to route_to(
        controller: 'admin/needs',
        action: 'show',
        id: ':id')
    end

    it 'routes GET /admin/needs/:id/edit to admin/needs#edit' do
      expect(get: '//admin/needs/:id/edit').to route_to(
        controller: 'admin/needs',
        action: 'edit',
        id: ':id')
    end

    it 'routes PATCH /admin/needs/:id to admin/needs#update' do
      expect(patch: 'admin/needs/:id').to route_to(
        controller: 'admin/needs',
        action: 'update',
        id: ':id')
    end
  end

  describe 'named routes' do
    it 'routes GET admin_needs_path to admin/needs#index' do
      expect(get: admin_needs_path).to route_to(
        controller: 'admin/needs',
        action: 'index',
        locale: 'de')
    end

    it 'routes GET admin_need_path(id) to admin/needs#show' do
      expect(get: admin_need_path('id')).to route_to(
        controller: 'admin/needs',
        action: 'show',
        id: 'id',
        locale: 'de')
    end

    it 'routes GET edit_admin_need_path(id) to admin/needs#edit' do
      expect(get: edit_admin_need_path('id')).to route_to(
        controller: 'admin/needs',
        action: 'edit',
        id: 'id',
        locale: 'de')
    end

    it 'routes PATCH admin_need_path(id) to admin/needs#update' do
      expect(patch: admin_need_path('id')).to route_to(
        controller: 'admin/needs',
        action: 'update',
        id: 'id',
        locale: 'de')
    end
  end
end
