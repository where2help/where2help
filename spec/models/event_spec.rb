require 'rails_helper'

RSpec.describe Event, type: :model do

  it { is_expected.to validate_presence_of :shift_length }
  it { is_expected.to validate_presence_of :address }
  it { is_expected.to validate_length_of :title }

  it { is_expected.to have_many(:shifts).dependent :destroy }

  it { is_expected.to accept_nested_attributes_for :shifts }
end
