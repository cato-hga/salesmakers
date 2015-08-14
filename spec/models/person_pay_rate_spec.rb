# == Schema Information
#
# Table name: person_pay_rates
#
#  id                                          :integer          not null, primary key
#  person_id                                   :integer          not null
#  wage_type                                   :integer          not null
#  rate                                        :float            not null
#  effective_date                              :date             not null
#  created_at                                  :datetime         not null
#  updated_at                                  :datetime         not null
#  connect_business_partner_salary_category_id :string
#

require 'rails_helper'

describe PersonPayRate do
end
