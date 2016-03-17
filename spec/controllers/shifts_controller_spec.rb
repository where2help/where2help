require 'rails_helper'

RSpec.describe ShiftsController, type: :controller do
  describe 'GET index' do
    before { get :index }

    it 'returns a 200 success' do
      expect(response).to have_http_status 200
    end
  end
end
