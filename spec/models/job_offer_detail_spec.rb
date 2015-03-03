require 'rails_helper'

describe JobOfferDetail do

  let(:job_offer) { build :job_offer_detail }
  describe 'validations' do
    it 'requires a candidate' do
      job_offer.candidate_id = nil
      expect(job_offer).not_to be_valid
    end
    it 'requires a sent date' do
      job_offer.sent = nil
      expect(job_offer).not_to be_valid
    end
  end
end