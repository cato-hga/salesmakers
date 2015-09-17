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
  belongs_to :connect_business_partner_location,
             primary_key: 'c_bpartner_location_id',
             foreign_key: 'c_bpartner_location_id'

  def shift_date
    self[:shift_date].to_time.remove_eastern_offset
  end

  def project
    bpl = self.connect_business_partner_location || return
    cr = bpl.connect_region || return
    division = cr.division || return
    division.name == 'Vonage Events Division' ? Project.find_by(name: 'Vonage Events') : Project.find_by(name: 'Vonage')
  end

  def self.this_week
    beginning_date_time = Date.today.beginning_of_week.to_datetime
    self.where('shift_date >= ?', beginning_date_time)
  end

  def self.this_month
    beginning_date_time = Date.today.beginning_of_month.to_datetime
    self.where('shift_date >= ?', beginning_date_time)
  end

  def self.totals_by_person_for_date_range start_date, end_date
    connection.execute %{
      select

      u.ad_user_id as connect_user_id,
      floor(round(sum(t.hours) + sum(t.overtime), 2)) as hours

      from rc_timesheet t
      left outer join ad_user u
        on u.ad_user_id = t.ad_user_id

      where
        t.shift_date >= cast('#{start_date.strftime('%m/%d/%Y')}' as timestamp)
        and t.shift_date <= cast('#{end_date.strftime('%m/%d/%Y')}' as timestamp)

      group by u.ad_user_id
      order by u.ad_user_id
    }
  end
end
