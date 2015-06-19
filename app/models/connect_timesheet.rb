# == Schema Information
#
# Table name: rc_timesheet
#
#  rc_timesheet_id        :string(32)       not null, primary key
#  createdby              :string(32)       not null
#  updatedby              :string(32)       not null
#  isactive               :string(1)        default("Y"), not null
#  ad_client_id           :string(32)       not null
#  ad_org_id              :string(32)       not null
#  shift_date             :datetime         not null
#  hours                  :decimal(, )      not null
#  ad_user_id             :string(32)       not null
#  created                :datetime         not null
#  updated                :datetime         not null
#  c_bpartner_location_id :string(32)
#  time_docked            :decimal(, )      default(0.0), not null
#  overtime               :decimal(, )      default(0.0), not null
#  rate_of_pay            :string(255)
#  customer               :string(255)
#  punch_ins              :string(255)
#  punch_outs             :string(255)
#  break_starts           :string(255)
#  break_ends             :string(255)
#

# Openbravo shifts
class ConnectTimesheet < RealConnectModel
  include ConnectScopes

  # Openbravo table name
  self.table_name = 'rc_timesheet'
  # Openbravo table primary key column
  self.primary_key = 'rc_timesheet_id'

  # Relationship for the Openbravo asset records
  belongs_to :connect_user,
           primary_key: 'ad_user_id',
           foreign_key: 'ad_user_id'

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
