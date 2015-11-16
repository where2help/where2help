require 'rails_helper'

RSpec.describe Admin::UsersController, type: :routing do

  describe 'routes' do

    it 'routes GET /users to admin/users/index' do
      expect(get: '/admin/users').to route_to('admin/users#index')
    end
  end
end
