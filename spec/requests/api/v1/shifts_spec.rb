require 'rails_helper'

RSpec.describe "Shifts", :type => :request do
  describe "POST /opt_in" do
    it 'creates a participation' do
      shift = create(:shift, :skip_validate)
      post "/api/v1/shifts/opt_in", params: { shift_id: shift.id }, 
                                    headers: token_header,
                                    as: :json

      expect(response).to be_success
      expect(json).to include_json({opted_id: true})
      expect(Participation.find_by(shift_id: shift.id, user_id: User.first.id)).to be_a Participation
    end
  end

  describe "POST /opt_out" do
    it 'deletes a participation' do
      shift = create(:shift, :skip_validate)
      post "/api/v1/shifts/opt_in", params: { shift_id: shift.id }, 
                                    headers: token_header,
                                    as: :json

      post "/api/v1/shifts/opt_out", params: { shift_id: shift.id }, 
                                     headers: {"Authorization": "Token token=" + response.headers["TOKEN"]},
                                     as: :json

      expect(response).to be_success
      expect(json).to include_json({opted_out: true})
      expect(Participation.find_by(shift_id: shift.id, user_id: User.first.id)).to be nil
    end

    it 'captures the situation of a non exsting shift' do
      post "/api/v1/shifts/opt_out", params: { shift_id: 42 }, 
                                     headers: token_header,
                                     as: :json
      expect(response).to be_not_found
      expect(json).to include_json({opted_out: false})
    end
  end
end
