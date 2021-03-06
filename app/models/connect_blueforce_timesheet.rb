# == Schema Information
#
# Table name: rsprint_timesheet
#
#  rsprint_timesheet_id   :string(32)       not null, primary key
#  createdby              :string(32)       not null
#  updatedby              :string(32)       not null
#  created                :datetime         not null
#  updated                :datetime         not null
#  isactive               :string(1)        default("Y"), not null
#  ad_client_id           :string(32)       not null
#  ad_org_id              :string(32)       not null
#  shift_date             :datetime         not null
#  employee_login         :string(255)
#  site_num               :string(255)      not null
#  site_name              :string(255)      not null
#  eid                    :string(255)      not null
#  first_name             :string(255)      not null
#  last_name              :string(255)      not null
#  hours                  :decimal(, )      not null
#  timesheet_row          :string(255)      not null
#  c_bpartner_location_id :string(32)
#  ad_user_id             :string(32)
#

# Openbravo shifts
class ConnectBlueforceTimesheet < RealConnectModel
  # Openbravo table name
  self.table_name = 'rsprint_timesheet'
  # Openbravo table primary key column
  self.primary_key = 'rsprint_timesheet_id'

  # Relationship for the Openbravo asset records
  belongs_to :connect_user,
           primary_key: 'ad_user_id',
           foreign_key: 'ad_user_id'
  belongs_to :connect_business_partner_location,
             primary_key: 'c_bpartner_location_id',
             foreign_key: 'c_bpartner_location_id'

  scope :updated_within_last, ->(duration) {
    return none unless duration
    where('updated >= ?', (Time.zone.now - duration).apply_eastern_offset)
  }

  scope :shifts_within_last, ->(duration) {
    return none unless duration
    where('shift_date >= ?',
          (Time.zone.now - duration).beginning_of_day.apply_eastern_offset).order(:ad_user_id, :shift_date)
  }

  def shift_date
    self[:shift_date].to_time.remove_eastern_offset
  end

  def project
    if self.site_num && self.site_num.include?('SPTR')
      return Project.find_by(name: 'Sprint Prepaid')
    elsif self.site_num && self.site_num.include?('POSTTR')
      return Project.find_by(name: 'STAR')
    end
    bpl = self.connect_business_partner_location || return
    cr = bpl.connect_region || return
    cp = cr.project || return
    case cp.name
      when 'Sprint Postpaid'
        Project.find_by(name: 'STAR')
      when 'Sprint'
        Project.find_by(name: 'Sprint Prepaid')
      when 'DirecTV'
        Project.find_by(name: 'DirecTV Retail')
      when 'Comcast'
        Project.find_by(name: 'Comcast Retail')
      else
        nil
    end
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
      floor(round(sum(t.hours), 2)) as hours

      from rsprint_timesheet t
      left outer join ad_user u
        on u.ad_user_id = t.ad_user_id

      where
        t.shift_date >= cast('#{start_date.strftime('%m/%d/%Y')}' as timestamp)
        and t.shift_date <= cast('#{end_date.strftime('%m/%d/%Y')}' as timestamp)
        and t.ad_user_id is not null

      group by u.ad_user_id
      order by u.ad_user_id
    }
  end
end
