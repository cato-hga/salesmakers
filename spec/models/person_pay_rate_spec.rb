# == Schema Information
#
# Table name: person_pay_rates
#
#  id                                          :integer          not null, primary key
#  person_id                                   :integer          not null
#  wage_type                                   :integer          not null
#  rate                                        :float            not null
#  effective_date                              :date             not null
#  created_at                                  :datetime         not null
#  updated_at                                  :datetime         not null
#  connect_business_partner_salary_category_id :string
#

require 'rails_helper'

describe PersonPayRate do
  subject { build :person_pay_rate }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a person' do
    subject.person = nil
    expect(subject).not_to be_valid
  end

  it 'requires a wage_type' do
    subject.wage_type = nil
    expect(subject).not_to be_valid
  end

  it 'requires a rate at least 7.50 or above' do
    subject.rate = 7.49
    expect(subject).not_to be_valid
  end

  it 'requires an effective_date' do
    subject.effective_date = nil
    expect(subject).not_to be_valid
  end
end
