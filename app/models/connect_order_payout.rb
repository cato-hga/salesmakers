#TODO: TEST ME
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
