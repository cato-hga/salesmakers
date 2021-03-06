# == Schema Information
#
# Table name: vonage_refunds
#
#  id                              :integer          not null, primary key
#  vonage_sale_id                  :integer          not null
#  vonage_account_status_change_id :integer          not null
#  refund_date                     :date             not null
#  person_id                       :integer          not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#

require 'rails_helper'

describe VonageRefund do
  let!(:vonage_mac_prefix) { create :vonage_mac_prefix }
  subject { build :vonage_refund }

  it 'does not allow duplicates' do
    subject.save
    new_refund = build :vonage_refund,
                       vonage_sale: subject.vonage_sale,
                       person: subject.person,
                       refund_date: Date.tomorrow
    expect(new_refund).not_to be_valid
  end
end
