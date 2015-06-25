# == Schema Information
#
# Table name: docusign_noses
#
#  id                       :integer          not null, primary key
#  person_id                :integer          not null
#  eligible_to_rehire       :boolean          default(FALSE), not null
#  termination_date         :datetime
#  last_day_worked          :datetime
#  employment_end_reason_id :integer
#  remarks                  :text
#  envelope_guid            :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  third_party              :boolean          default(FALSE), not null
#  manager_id               :integer
#

require 'rails_helper'

describe DocusignNos do

  describe 'validations' do
    let(:nos) { build_stubbed :docusign_nos }
    let(:manager) { build_stubbed :person }
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

    it 'does not require most attributes if it is a third party nos' do
      expect(nos).to be_valid
      nos.termination_date = nil
      nos.last_day_worked = nil
      nos.employment_end_reason_id = nil
      nos.eligible_to_rehire = nil
      expect(nos).not_to be_valid
      nos.third_party = true
      nos.manager_id = manager.id
      expect(nos).to be_valid
    end

    it 'requires a manager_id if it is a third party NOS' do
      nos.third_party = true
      nos.manager_id = nil
      expect(nos).not_to be_valid
      nos.third_party = false
      expect(nos).to be_valid
    end
  end
end
