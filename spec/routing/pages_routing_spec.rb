require 'rails_helper'

RSpec.describe PagesController, type: :routing do
  describe 'routes ' do
    it 'routes GET privacy to #privacy' do
      expect(get: 'privacy').to route_to 'pages#privacy'
    end
  end

  describe 'named routes' do
    it 'routes GET privacy_path to #privacy' do
      expect(get: privacy_path).to route_to 'pages#privacy'
    end
  end
end
