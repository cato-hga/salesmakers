require 'rails_helper'

describe Candidate do
  let(:candidate) { build :candidate, mobile_phone: '7164158131' }

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

    it 'requires a created_by Person' do
      candidate.created_by = nil
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
    let(:second_candidate) { build :candidate, mobile_phone: '7164158131' }
    it 'has unique mobile phone numbers' do
      candidate.save
      expect(second_candidate).not_to be_valid
    end
  end
end