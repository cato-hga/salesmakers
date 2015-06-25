# == Schema Information
#
# Table name: rc_order_payout
#
#  rc_order_payout_id :string(32)       not null, primary key
#  ad_client_id       :string(32)       not null
#  ad_org_id          :string(32)       not null
#  isactive           :string(1)        default("Y"), not null
#  created            :datetime         not null
#  createdby          :string(32)       not null
#  updated            :datetime         not null
#  updatedby          :string(32)       not null
#  ad_user_id         :string(32)       not null
#  hps                :decimal(, )      not null
#  payout             :decimal(, )      not null
#  rc_paycheck_id     :string(32)       not null
#  c_order_id         :string(32)       not null
#

# Openbravo commission payments
class ConnectOrderPayout < RealConnectModel
  # Openbravo table name
  self.table_name = 'rc_order_payout'
  # Openbravo table primary key column
  self.primary_key = 'rc_order_payout_id'

  # Relationship for the Openbravo asset records
  belongs_to :connect_user,
           primary_key: 'ad_user_id',
           foreign_key: 'ad_user_id'
  belongs_to :connect_order,
             primary_key: 'c_order_id',
             foreign_key: 'c_order_id'

  def self.this_week
    beginning_date_time = Date.today.beginning_of_week.to_datetime
    end_date_time = Date.today.end_of_week.to_datetime
    self.joins(:connect_order).where('dateordered >= ?', beginning_date_time).where('dateordered < ?', end_date_time)
  end
end
