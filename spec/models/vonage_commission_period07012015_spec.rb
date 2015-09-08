# == Schema Information
#
# Table name: vonage_commission_period07012015s
#
#  id                 :integer          not null, primary key
#  name               :string           not null
#  hps_start          :date
#  hps_end            :date
#  vested_sales_start :date
#  vested_sales_end   :date
#  cutoff             :datetime         not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'rails_helper'

describe VonageCommissionPeriod07012015 do
  subject { build :vonage_commission_period07012015 }

  it 'requires at least one of HPS period or vested sales period' do
    subject.hps_start, subject.hps_end = nil, nil
    subject.vested_sales_start, subject.vested_sales_end = nil, nil
    expect(subject).not_to be_valid
  end
end
