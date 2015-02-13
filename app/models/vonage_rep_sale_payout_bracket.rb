class VonageRepSalePayoutBracket < ActiveRecord::Base
  validates :per_sale, presence: true
  validates :area, presence: true
  validates :sales_minimum, presence: true, uniqueness: true
  validates :sales_maximum, presence: true, uniqueness: true

  belongs_to :area
end
