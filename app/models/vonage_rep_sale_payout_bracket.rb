# == Schema Information
#
# Table name: vonage_rep_sale_payout_brackets
#
#  id            :integer          not null, primary key
#  per_sale      :decimal(, )      not null
#  area_id       :integer          not null
#  sales_minimum :integer          not null
#  sales_maximum :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class VonageRepSalePayoutBracket < ActiveRecord::Base
  validates :per_sale, presence: true
  validates :area, presence: true
  validates :sales_minimum, presence: true, uniqueness: { scope: :area }
  validates :sales_maximum, presence: true, uniqueness: { scope: :area }

  belongs_to :area
end
