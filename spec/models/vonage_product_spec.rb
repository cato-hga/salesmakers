# == Schema Information
#
# Table name: vonage_products
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  price_range_minimum :decimal(, )      default(0.0), not null
#  price_range_maximum :decimal(, )      default(9999.99), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'rails_helper'

describe VonageProduct do
  subject(:vonage_product) { build :vonage_product }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

end
