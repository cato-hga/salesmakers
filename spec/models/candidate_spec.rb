require 'rails_helper'

describe Candidate do

  let(:candidate) { build :candidate }
  describe 'validations' do
    it 'requires a first name' do
      candidate.first_name = nil
      expect(candidate).not_to be_valid
    end
    it 'requires a last name' do
      candidate.last_name = nil
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
    it 'requires a zip code' do
      candidate.zip = nil
      expect(candidate).not_to be_valid
    end
    it 'requires a project' do
      candidate.project_id = nil
      expect(candidate).not_to be_valid
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
    let(:second_candidate) { build :candidate }
    it 'has unique mobile phone numbers' do
      candidate.save
      expect(second_candidate).not_to be_valid
    end
  end
end