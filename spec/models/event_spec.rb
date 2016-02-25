require 'rails_helper'

RSpec.describe Event, type: :model do

  it { is_expected.to validate_presence_of(:category)}
  it { is_expected.to validate_presence_of(:volunteers_needed)}
  it { is_expected.to validate_presence_of(:starts_at)}
  it { is_expected.to validate_presence_of(:ends_at)}
  it { is_expected.to validate_presence_of(:shift_length)}
  it { is_expected.to validate_presence_of(:address)}

  it { is_expected.to define_enum_for(:category).with([:volunteer, :medical, :legal])}

  it { is_expected.to have_many(:shifts) }

end
