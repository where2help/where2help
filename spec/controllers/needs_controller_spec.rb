require 'rails_helper'

RSpec.describe NeedsController, type: :controller do

  describe 'GET list' do
    context 'when html request' do

      it 'assigns first 10 @needs' do
        expect(assigns(:needs).size).to eq 5
      end

      it 'renders list.html' do
        expect(response['Content-Type']).to eq 'text/html; charset=utf-8'
        expect(response).to render_template(:list)
      end
    end
  end

  context 'when ajax request' do

    it 'assigns @needs' do
      expect(assigns(:needs)).to eq be
    end

    it 'renders list.js' do
      expect(response['Content-Type']).to eq 'text/javascript; charset=utf-8'
      expect(response).to render_template(:list)
    end
  end
end
