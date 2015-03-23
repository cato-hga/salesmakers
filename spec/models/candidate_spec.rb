require 'rails_helper'

describe Candidate do
  let(:candidate) { build :candidate, mobile_phone: '7164158131', personality_assessment_status: :incomplete }

  describe 'validations' do
    it 'requires a first name at least 2 characters long' do
      candidate.first_name = 'a'
      expect(candidate).not_to be_valid
    end
    it 'requires a last name at least 2 characters long' do
      candidate.last_name = 'a'
      expect(candidate).not_to be_valid
    end
    it 'requires a mobile phone' do
      candidate.mobile_phone = nil
      expect(candidate).not_to be_valid
    end
    it 'requires an email address' do
      candidate.email = nil
      expect(candidate).not_to be_valid
    end
    it 'requires a zip code exactly 5 digits long' do
      candidate.zip = nil
      expect(candidate).not_to be_valid
      candidate.zip = '1234'
      expect(candidate).not_to be_valid
      candidate.zip = '123456'
      expect(candidate).not_to be_valid
    end

    it 'requires a created_by Person' do
      candidate.created_by = nil
      expect(candidate).not_to be_valid
    end

    it 'requires a source' do
      candidate.candidate_source_id = nil
      expect(candidate).not_to be_valid
    end

    it 'responds to personality_assessment_completed?' do
      expect(candidate).to respond_to(:personality_assessment_completed?)
    end

    it 'responds to personality_assessment_status' do
      expect(candidate).to respond_to(:personality_assessment_status)
    end

    it 'responds to personality_assessment_score' do
      expect(candidate).to respond_to(:personality_assessment_score)
    end
  end

  describe 'personality assessment requirements' do
    let(:area) {
      build_stubbed :area,
                    personality_assessment_url: 'https://google.com'
    }
    let(:location_area) { build_stubbed :location_area, area: area }

    describe 'when a personality assessment URL is present on the area' do
      before do
        candidate.location_area = location_area
      end

      it 'does not show that the candidate passed the assessment if not completed' do
        expect(candidate.passed_personality_assessment?).to be_falsey
      end

      it 'shows that the candidate passed the assessment if completed' do
        candidate.personality_assessment_completed = true
        expect(candidate.passed_personality_assessment?).to be_truthy
      end
    end

    describe 'when there is no location_area on the candidate' do
      it 'does not show that the candidate passed the assessment' do
        expect(candidate.passed_personality_assessment?).to be_falsey
      end
    end

    describe 'when there is no personality assessment URL on the area' do
      before do
        second_location_area = build_stubbed :location_area
        candidate.location_area = second_location_area
      end

      it 'shows that the candidate passed the personality assessment' do
        expect(candidate.passed_personality_assessment?).to be_truthy
      end
    end
  end

  describe 'mobile phone additional actions' do
    let(:candidate) { create :candidate }
    it 'cleans the phone numbers' do
      candidate.mobile_phone = '716-415-8130'
      candidate.save
      expect(candidate.mobile_phone).to eq('7164158130')
    end
  end

  describe 'uniqueness' do
    let(:second_candidate) { build :candidate, mobile_phone: '7164158131' }
    it 'has unique mobile phone numbers' do
      candidate.save
      expect(second_candidate).not_to be_valid
    end
  end
end