# == Schema Information
#
# Table name: vcp07012015_hps_sales
#
#  id                                  :integer          not null, primary key
#  vonage_commission_period07012015_id :integer          not null
#  vonage_sale_id                      :integer          not null
#  person_id                           :integer          not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#

class VCP07012015HPSSale < ActiveRecord::Base
  validates :vonage_commission_period07012015, presence: true
  validates :vonage_sale, presence: true
  validates :person, presence: true

  belongs_to :vonage_commission_period07012015
  belongs_to :vonage_sale
  belongs_to :person
end
