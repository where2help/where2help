require 'rails_helper'

RSpec.describe UsersController, type: :routing do

  describe 'singular routes' do

    it 'routes GET /user to users#show' do
      expect(get: '/user').to route_to('users#show')
    end

    it 'does not route GET /user/new' do
      expect(get: '/user/new').not_to route_to('users#new')
    end

    it 'does not route POST /user' do
      expect(post: '/user').not_to route_to('users#create')
    end

    it 'does not route GET /user/edit' do
      expect(get: '/user/edit').not_to route_to('users#edit')
    end

    it 'does not route PUT /user' do
      expect(put: '/user').not_to route_to('users#update')
    end

    it 'does not route DELETE /user' do
      expect(delete: '/users').not_to route_to('users#destroy')
    end
  end

  describe 'plural routes' do

    it 'does not route GET /users' do
      expect(get: '/users').not_to be_routable
    end

    it 'does not route GET /users/new' do
      expect(get: '/users/new').not_to route_to('users#new')
    end

    it 'does not route POST /users' do
      expect(post: '/users').not_to route_to('users#create')
    end

    it 'does not route GET /users/:id' do
      expect(get: '/users/:id').not_to route_to('users#show')
    end

    it 'does not route GET /users/:id/edit' do
      expect(get: '/users/:id/edit').not_to route_to('users#edit')
    end

    it 'does not route PUT /users/:id' do
      expect(put: '/users/:id').not_to route_to('users#update')
    end

    it 'does not route DELETE /users/:id' do
      expect(delete: '/users/:id').not_to route_to('users#destroy')
    end
  end

  describe 'named routes' do

    it 'routes GET user_path to users#show' do
      expect(get: user_path).to route_to(
        controller: 'users',
        action: 'show',
        locale: 'de')
    end
  end
end
