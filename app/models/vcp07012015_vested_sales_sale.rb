class VCP07012015VestedSalesSale < ActiveRecord::Base
  validates :vonage_commission_period07012015, presence: true
  validates :vonage_sale, presence: true
  validates :person, presence: true
  validates :vested, inclusion: { in: [true, false] }

  belongs_to :vonage_commission_period07012015
  belongs_to :vonage_sale
  belongs_to :person
end