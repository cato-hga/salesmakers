#TODO: TEST ME
# Openbravo orders
class ConnectOrder < RealConnectModel
  # Openbravo table name
  self.table_name = 'c_order'
  # Openbravo table primary key column
  self.primary_key = 'c_order_id'

  # Relationship for the Openbravo asset records
  belongs_to :connect_user,
           primary_key: 'ad_user_id',
           foreign_key: 'salesrep_id'
  has_many :connect_order_payouts,
           foreign_key: 'ad_user_id'

  def self.this_week
    beginning_date_time = Date.today.beginning_of_week.to_datetime
    end_date_time = Date.today.end_of_week.to_datetime
    self.where('dateordered >= ?', beginning_date_time).where('dateordered < ?', end_date_time)
  end

  def self.this_month
    beginning_date_time = Date.today.beginning_of_month.to_datetime
    end_date_time = Date.today.end_of_week.to_datetime
    self.where('dateordered >= ?', beginning_date_time).where('dateordered < ?', end_date_time)
  end

  def self.sales
    self.where "documentno LIKE '%+'"
  end

  def self.refunds
    self.where "documentno LIKE '%-'"
  end
end
