# == Schema Information
#
# Table name: drop_off_reasons
#
#  id                      :integer          not null, primary key
#  name                    :string           not null
#  active                  :boolean          default(TRUE), not null
#  eligible_for_reschedule :boolean          default(TRUE), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

describe DropOffReason do

  describe 'validations' do
    let(:reason) { build :drop_off_reason }

    it 'requires active y/n' do
      reason.active = nil
      expect(reason).not_to be_valid
    end

    it 'requires eligible y/n' do
      reason.eligible_for_reschedule = nil
      expect(reason).not_to be_valid
    end
  end

end
