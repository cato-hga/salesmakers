require 'rails_helper'

describe Candidate do
  let(:candidate) { build :candidate, mobile_phone: '7164158131', personality_assessment_status: :incomplete }

  it 'trims the names' do
    candidate.first_name = ' Foo '
    candidate.last_name = ' Bar '
    candidate.save
    candidate.reload
    expect(candidate.first_name).to eq('Foo')
    expect(candidate.last_name).to eq('Bar')
  end

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
    it 'requires a mobile phone exactly 10 digits in length' do
      candidate.mobile_phone = '80055512121'
      expect(candidate).not_to be_valid
      candidate.mobile_phone = '800555121'
      expect(candidate).not_to be_valid
    end
    it 'does not validate mobile phone length for existing records' do
      candidate.mobile_phone = '800555121'
      candidate.save validate: false
      expect(candidate).to be_valid
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

    it 'requires a unique email without case sensitivity' do
      email = 'foo@bar.com'
      create :candidate, email: email.upcase
      candidate.email = email
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

    it 'responds to sprint_radio_shack_training_session' do
      expect(candidate).to respond_to(:sprint_radio_shack_training_session)
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

      it 'does not show that the candidate passed the assessment when disqualified' do
        candidate.personality_assessment_completed = true
        candidate.personality_assessment_status = 'disqualified'
        expect(candidate.passed_personality_assessment?).to be_falsey
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

  describe '#prescreened?' do
    let(:prescreen_candidate) { create :candidate }
    let(:prescreen_answers) { create :prescreen_answer }
    let(:outsourced_location) { create :location_area, outsourced: true }
    it 'returns true if there are prescreen answers for a candidate' do
      prescreen_answers.update candidate: prescreen_candidate
      expect(prescreen_candidate.prescreened?).to eq(true)
    end
    it 'returns true if the candidates status is set to prescreened' do
      prescreen_candidate.update status: :prescreened
      expect(prescreen_candidate.prescreened?).to eq(true)
    end
    it 'returns true if the candidate is outsourced' do
      prescreen_candidate.update location_area: outsourced_location
      expect(prescreen_candidate.prescreened?).to eq(true)
    end
  end

  describe '#location_selected' do
    let(:location_candidate) { create :candidate }
    let(:location_area) { create :location_area }

    it 'returns true if the candidate has a location area' do
      location_candidate.update location_area: location_area
      expect(location_candidate.location_selected?).to eq(true)
    end

    it 'returns true if the candidates status is location_selected' do
      location_candidate.update status: :location_selected
      expect(location_candidate.location_selected?).to eq(true)
    end
  end

  describe '#outsourced?' do
    let(:outsource_candidate) { create :candidate }
    let(:source) { create :candidate_source, name: 'Outsourced' }
    let(:location_area) { create :location_area }
    it 'returns true if the candidate has a candidate source of "outsourced"' do
      expect(outsource_candidate.outsourced?).to eq(false)
      outsource_candidate.candidate_source = source
      expect(outsource_candidate.outsourced?).to eq(true)
    end
    it 'returns true if a candidate has a location area and if the location area is outsourced' do
      expect(outsource_candidate.outsourced?).to eq(false)
      outsource_candidate.location_area = location_area
      expect(outsource_candidate.outsourced?).to eq(false)
      location_area.outsourced = true
      expect(outsource_candidate.outsourced?).to eq(true)
    end
  end

  describe '.assign_potential_territories' do
    let(:candidate) { create :candidate, longitude: 5, latitude: 5 }
    let(:far_away_area) { create :area, name: 'Far Away Territory' }
    let(:far_away_location) { create :location, longitude: 99, latitude: 99 }
    let(:far_away_location_area) { create :location_area, location: far_away_location, area: far_away_area }
    let(:close_location) { create :location, longitude: 6, latitude: 6 }
    let(:close_area) { create :area, name: 'Close Area' }
    let(:close_location_area) { create :location_area, location: close_location, area: close_area }

    let(:location_areas) { [] }
    it 'sets the closest area as the candidates potential area' do
      location_areas << close_location_area
      location_areas << far_away_location_area
      candidate.assign_potential_territory(location_areas)
      candidate.reload
      expect(candidate.potential_area).to eq(close_area)
    end

    it 'handles a blank array' do
      expect(candidate.assign_potential_territory(location_areas)).to be_nil
    end
    it 'raises an exception with unordered arrays' do
      location_areas << far_away_location_area
      location_areas << close_location_area
      expect { candidate.assign_potential_territory(location_areas) }.to raise_error
    end
  end
end