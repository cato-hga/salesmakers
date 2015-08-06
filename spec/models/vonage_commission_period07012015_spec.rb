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

  it 'is valid with proper attributes' do
    expect(subject).to be_valid
  end

  it 'requires a name at least 4 characters long' do
    subject.name = nil
    expect(subject).not_to be_valid
    subject.name = 'a'*3
    expect(subject).not_to be_valid
  end

  it 'requires at least one of HPS period or vested sales period' do
    subject.hps_start, subject.hps_end = nil, nil
    subject.vested_sales_start, subject.vested_sales_end = nil, nil
    expect(subject).not_to be_valid
  end

  it 'requires a cutoff' do
    subject.cutoff = nil
    expect(subject).not_to be_valid
  end

  it 'responds to vcp07012015_vested_sales_sales' do
    expect(subject).to respond_to :vcp07012015_vested_sales_sales
  end
end
