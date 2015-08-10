# == Schema Information
#
# Table name: job_offer_details
#
#  id                     :integer          not null, primary key
#  candidate_id           :integer          not null
#  sent                   :datetime         not null
#  completed              :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  envelope_guid          :string
#  completed_by_candidate :datetime
#  completed_by_advocate  :datetime
#

require 'rails_helper'

describe JobOfferDetail do

  let(:job_offer) { build :job_offer_detail }
  describe 'validations' do
    it 'requires a candidate' do
      job_offer.candidate_id = nil
      expect(job_offer).not_to be_valid
    end
    it 'requires a sent date and time' do
      job_offer.sent = nil
      expect(job_offer).not_to be_valid
    end
    it 'allows an envelope_guid' do
      expect(job_offer).to respond_to(:envelope_guid)
    end
  end
end
