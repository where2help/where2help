require 'rails_helper'

RSpec.describe VolunteeringsController, type: :routing do

  describe 'routes' do

    it 'routes POST /volunteerings to volunteerings#create' do
      expect(post: 'volunteerings').to route_to(
        controller: 'volunteerings',
        action: 'create')
    end

    it 'routes DELETE /volunteerings/id to volunteerings#destroy' do
      expect(delete: 'volunteerings/id').to route_to(
        controller: 'volunteerings',
        action: 'destroy',
        id: 'id')
    end
  end

  describe 'named routes' do

    it 'routes POST volunteerings_path to volunteerings#create' do
      expect(post: volunteerings_path).to route_to(
        controller: 'volunteerings',
        action: 'create',
        locale: 'de')
    end

    it 'routes DELETE volunteerings_path to volunteerings#destroy' do
      expect(delete: volunteering_path('id')).to route_to(
        controller: 'volunteerings',
        action: 'destroy',
        id: 'id',
        locale: 'de')
    end
  end
end
