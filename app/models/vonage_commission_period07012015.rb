# == Schema Information
#
# Table name: vonage_commission_period07012015s
#
#  id                 :integer          not null, primary key
#  name               :string           not null
#  hps_start          :date
#  hps_end            :date
#  vested_sales_start :date
#  vested_sales_end   :date
#  cutoff             :datetime         not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class VonageCommissionPeriod07012015 < ActiveRecord::Base
  validates :name, length: { minimum: 4 }
  validate :at_least_one_period
  validates :cutoff, presence: true

  has_many :vcp07012015_hps_sales
  has_many :vcp07012015_hps_shifts
  has_many :vcp07012015_vested_sales_shifts
  has_many :vcp07012015_vested_sales_sales

  private

  def at_least_one_period
    unless (hps_start && hps_end) || (vested_sales_start && vested_sales_end)
      errors.add :vested_sales_start, ' and end or HPS start and end must be filled out'
    end
  end
end
