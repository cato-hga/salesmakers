# == Schema Information
#
# Table name: comcast_lead_dismissal_reasons
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe ComcastLeadDismissalReason do
  
  let(:reason) { build :comcast_lead_dismissal_reason }

  it 'requires an active Y/N' do
    reason.active = nil
    expect(reason).not_to be_valid
  end

end
