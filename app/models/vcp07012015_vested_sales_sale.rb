# == Schema Information
#
# Table name: vcp07012015_vested_sales_sales
#
#  id                                  :integer          not null, primary key
#  vonage_commission_period07012015_id :integer          not null
#  vonage_sale_id                      :integer          not null
#  person_id                           :integer          not null
#  vested                              :boolean          default(FALSE), not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#

class VCP07012015VestedSalesSale < ActiveRecord::Base
  validates :vonage_commission_period07012015, presence: true
  validates :vonage_sale, presence: true
  validates :person, presence: true
  validates :vested, inclusion: { in: [true, false] }

  belongs_to :vonage_commission_period07012015
  belongs_to :vonage_sale
  belongs_to :person
end
