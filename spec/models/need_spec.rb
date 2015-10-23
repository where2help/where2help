require 'rails_helper'

RSpec.describe Need, type: :model do

  it 'has a valid factory' do
    expect(build_stubbed(:need)).to be_valid
  end

  describe 'attributes' do
    let(:need) { create(:need) }

    it 'has category (default :general)' do
      expect(need).to respond_to(:category)
      expect(need.general?).to be_truthy
    end

    it 'has volunteers_needed (default 1)' do
      expect(need).to respond_to(:volunteers_needed)
      expect(need.volunteers_needed).to eq 1
    end

    describe 'volunteerings_count' do

      it 'has volunteerings_count' do
        expect(need).to respond_to(:volunteerings_count)
      end

      it 'has default value 0' do
        expect(need.volunteerings_count).to eq 0
      end

      it 'changes with association count' do
        expect{
          create(:volunteering, need: need)
          need.reload
        }.to change{need.volunteerings_count}.from(0).to(1)
      end
    end
  end

  describe 'associations' do
    let(:need) { build(:need) }

    it 'has user' do
      expect(need).to respond_to(:user)
    end

    it 'has volunteers' do
      expect(need).to respond_to(:volunteers)
    end
  end

  describe 'scopes' do
    describe 'upcoming' do
      let!(:need_day_after_tomorrow) { create(:need, start_time: Time.now+2.days) }
      let!(:need_today) { create(:need, start_time: Time.now+5.seconds) }
      let!(:need_tomorrow) { create(:need, start_time: Time.now+1.day) }
      let!(:need_yesterday) { create(:need, start_time: Time.now-1.day) }

      subject(:needs) { Need.upcoming }

      it 'retrieves nearest first (ignore :created_at)' do
        expect(needs.to_a).to eq [need_today, need_tomorrow, need_day_after_tomorrow]
      end

      it 'excludes past' do
        expect(needs).not_to include(need_yesterday)
      end
    end

    describe 'fulfilled' do
      let!(:need_fulfilled) { create(:need, volunteerings_count: 1) }
      let!(:need_over_fulfilled) { create(:need, volunteerings_count: 2) }
      let!(:need_unfulfilled) { create(:need) }

      subject(:needs) { Need.fulfilled }

      it 'retrieves where all volunteer slots filled or more' do
        expect(needs).to include(need_fulfilled, need_over_fulfilled)
      end

      it 'excludes unfulfilled' do
        expect(needs).not_to include(need_unfulfilled)
      end
    end

    describe 'unfulfilled' do
      let!(:need_fulfilled) { create(:need, volunteerings_count: 1) }
      let!(:need_over_fulfilled) { create(:need, volunteerings_count: 2) }
      let!(:need_unfulfilled) { create(:need) }

      subject(:needs) { Need.unfulfilled }

      it 'excludes where all volunteer slots filled or more' do
        expect(needs).not_to include(need_fulfilled, need_over_fulfilled)
      end

      it 'includes unfulfilled' do
        expect(needs).to include(need_unfulfilled)
      end
    end
  end

  describe '.categories_for_select' do
    it 'is a pending example'    
  end

  describe '#volunteers_needed?' do
    it 'is a pending example'
  end

  describe '#i18n_category' do
    it 'is a pending example'
  end
end
