# == Schema Information
#
# Table name: vonage_sale_payouts
#
#  id                 :integer          not null, primary key
#  vonage_sale_id     :integer          not null
#  person_id          :integer          not null
#  payout             :decimal(, )      not null
#  vonage_paycheck_id :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  day_62             :boolean          default(FALSE), not null
#  day_92             :boolean          default(FALSE), not null
#  day_122            :boolean          default(FALSE), not null
#  day_152            :boolean          default(FALSE), not null
#

class VonageSalePayout < ActiveRecord::Base
  validates :vonage_sale, presence: true, uniqueness: { scope: [:person, :day_62, :day_92, :day_122, :day_152] }
  validates :person, presence: true
  validates :payout, presence: true
  validates :vonage_paycheck, presence: true

  belongs_to :vonage_sale
  belongs_to :person
  belongs_to :vonage_paycheck

  default_scope {
    joins(:vonage_sale).
        order("vonage_sales.sale_date").
        includes(:vonage_sale)
  }
end
