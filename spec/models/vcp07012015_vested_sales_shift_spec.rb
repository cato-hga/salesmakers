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

require 'rails_helper'

describe VCP07012015VestedSalesShift do
end
