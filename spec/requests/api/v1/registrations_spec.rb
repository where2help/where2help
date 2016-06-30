require 'rails_helper'

RSpec.describe "Registrations", :type => :request do
  describe "GET /authors/:id" do
    it 'sends a list of messages' do

#      get '/api/v1/registrations'

      json = JSON.parse(response.body)

      expect(response).to be_success

      expect(json['messages'].length).to eq(10)
    end
  end
end