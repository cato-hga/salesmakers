require 'rails_helper'

describe DocusignNos do

  describe 'validations' do
    let(:nos) { build_stubbed :docusign_nos }
    it 'requires an eligible to rehire decision' do
      nos.eligible_to_rehire = nil
      expect(nos).not_to be_valid
    end
    it 'requires an employment end reason id' do
      nos.employment_end_reason_id = nil
      expect(nos).not_to be_valid
    end
    it 'requires an envelope guid' do
      nos.envelope_guid = nil
      expect(nos).not_to be_valid
    end
    it 'requires a last day worked' do
      nos.last_day_worked = nil
      expect(nos).not_to be_valid
    end
    it 'requires a person' do
      nos.person_id = nil
      expect(nos).not_to be_valid
    end
    it 'requires a termination_date' do
      nos.termination_date = nil
      expect(nos).not_to be_valid
    end
  end
end