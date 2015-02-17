class VonageRepSalePayoutBracket < ActiveRecord::Base
  validates :per_sale, presence: true
  validates :area, presence: true
  validates :sales_minimum, presence: true, uniqueness: { scope: :area }
  validates :sales_maximum, presence: true, uniqueness: { scope: :area }

  belongs_to :area
end
