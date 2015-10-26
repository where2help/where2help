require 'rails_helper'

RSpec.describe Volunteers::NeedsController, type: :routing do

  describe 'routes' do

    it 'routes GET /user/appointments to volunteers/needs#index' do
      expect(get: 'user/appointments').to route_to(
        controller: 'volunteers/needs',
        action: 'index')
    end
  end

  describe 'named routes' do

    it 'routes GET appointments_user_path to volunteers/needs#index' do
      expect(get: appointments_user_path).to route_to(
        controller: 'volunteers/needs',
        action: 'index')
    end
  end
end
