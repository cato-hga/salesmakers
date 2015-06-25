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

class VonageProduct < ActiveRecord::Base
  validates :name, length: { minimum: 2 }
end
