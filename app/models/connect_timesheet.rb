# Openbravo shifts
class ConnectTimesheet < RealConnectModel
  # Openbravo table name
  self.table_name = 'rc_timesheet'
  # Openbravo table primary key column
  self.primary_key = 'rc_timesheet_id'

  # Relationship for the Openbravo asset records
  belongs_to :connect_user,
           primary_key: 'ad_user_id',
           foreign_key: 'ad_user_id'

  scope :updated_within_last, ->(duration) {
    return none unless duration
    where('updated >= ?', (Time.zone.now - duration).apply_eastern_offset)
  }

  def shift_date
    self[:shift_date].to_time.remove_eastern_offset
  end

  def self.this_week
    beginning_date_time = Date.today.beginning_of_week.to_datetime
    self.where('shift_date >= ?', beginning_date_time)
  end

  def self.this_month
    beginning_date_time = Date.today.beginning_of_month.to_datetime
    self.where('shift_date >= ?', beginning_date_time)
  end
end
