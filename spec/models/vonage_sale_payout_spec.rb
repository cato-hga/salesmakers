# == Schema Information
#
# Table name: vonage_sale_payouts
#
#  id                 :integer          not null, primary key
#  vonage_sale_id     :integer          not null
#  person_id          :integer          not null
#  payout             :decimal(, )      not null
#  vonage_paycheck_id :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  day_62             :boolean          default(FALSE), not null
#  day_92             :boolean          default(FALSE), not null
#  day_122            :boolean          default(FALSE), not null
#  day_152            :boolean          default(FALSE), not null
#

require 'rails_helper'

describe VonageSalePayout do
  let!(:vonage_mac_prefix) { create :vonage_mac_prefix }
  let(:second_paycheck) {
    build :vonage_paycheck,
          wages_start: Date.yesterday,
          wages_end: Date.today,
          commission_start: Date.yesterday,
          commission_end: Date.today,
          cutoff: DateTime.now + 1.day
  }
  subject { build :vonage_sale_payout }

  it 'responds to day_62?' do
    expect(subject).to respond_to(:day_62?)
  end

  it 'responds to day_92?' do
    expect(subject).to respond_to(:day_92?)
  end

  it 'responds to day_122?' do
    expect(subject).to respond_to(:day_122?)
  end

  it 'responds to day_152?' do
    expect(subject).to respond_to(:day_152?)
  end

  it 'does not allow a duplicate VonageSale and Person combination' do
    subject.save
    duplicate = build :vonage_sale_payout,
                      vonage_paycheck: second_paycheck,
                      person: subject.person,
                      vonage_sale: subject.vonage_sale
    expect(duplicate).not_to be_valid
  end
end
