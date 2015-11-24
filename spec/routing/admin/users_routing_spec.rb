require 'rails_helper'

RSpec.describe Admin::UsersController, type: :routing do

  describe 'routes' do

    it 'routes GET /admin/users to admin/users#index' do
      expect(get: '/admin/users').to route_to('admin/users#index')
    end

    it 'routes GET /admin/users/:id to admin/users#show' do
      expect(get: 'admin/users/:id').to route_to(
        controller: 'admin/users',
        action: 'show',
        id: ':id')
    end

    it 'routes GET /admin/users/:id/edit to admin/users#edit' do
      expect(get: 'admin/users/:id/edit').to route_to(
        controller: 'admin/users',
        action: 'edit',
        id: ':id')
    end

    it 'routes POST /admin/users/:id/confirm to admin/users#confirm' do
      expect(post: 'admin/users/:id/confirm').to route_to(
        controller: 'admin/users',
        action: 'confirm',
        id: ':id')
    end

    it 'routes PUT /admin/users/:id to admin/users#update' do
      expect(put: 'admin/users/:id').to route_to(
        controller: 'admin/users',
        action: 'update',
        id: ':id')
    end

    it 'routes DELETE /admin/users/:id to admin/users#destroy' do
      expect(delete: 'admin/users/:id').to route_to(
        controller: 'admin/users',
        action: 'destroy',
        id: ':id')
    end
  end

  describe 'named routes' do

    it 'routes GET admin_users_path to admin/users#index' do
      expect(get: admin_users_path).to route_to(
        controller: 'admin/users',
        action: 'index',
        locale: 'de')
    end

    it 'routes GET admin_user_path(id) to admin/users#show' do
      expect(get: admin_user_path('id')).to route_to(
        controller: 'admin/users',
        action: 'show',
        id: 'id',
        locale: 'de')
    end

    it 'routes GET edit_admin_user_path(id) to admin/users#edit' do
      expect(get: edit_admin_user_path('id')).to route_to(
        controller: 'admin/users',
        action: 'edit',
        id: 'id',
        locale: 'de')
    end

    it 'routes POST confirm_admin_user_path(id) to admin/users#confirm' do
      expect(post: confirm_admin_user_path('id')).to route_to(
        controller: 'admin/users',
        action: 'confirm',
        id: 'id',
        locale: 'de')
    end

    it 'routes PUT admin_user_path(id) to admin/users#update' do
      expect(put: admin_user_path('id')).to route_to(
        controller: 'admin/users',
        action: 'update',
        id: 'id',
        locale: 'de')
    end

    it 'routes DELETE admin_user_path(id) to admin/users#destroy' do
      expect(delete: admin_user_path('id')).to route_to(
        controller: 'admin/users',
        action: 'destroy',
        id: 'id',
        locale: 'de')
    end
  end
end
