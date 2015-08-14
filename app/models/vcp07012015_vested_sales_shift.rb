# == Schema Information
#
# Table name: vcp07012015_vested_sales_shifts
#
#  id                                  :integer          not null, primary key
#  vonage_commission_period07012015_id :integer          not null
#  shift_id                            :integer          not null
#  person_id                           :integer          not null
#  hours                               :float            not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#

class VCP07012015VestedSalesShift < ActiveRecord::Base
  validates :vonage_commission_period07012015, presence: true
  validates :shift, presence: true
  validates :person, presence: true
  validates :hours, presence: true

  belongs_to :vonage_commission_period07012015
  belongs_to :shift
  belongs_to :person
end
