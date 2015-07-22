# == Schema Information
#
# Table name: sms_daily_checks
#
#  id                       :integer          not null, primary key
#  date                     :date             not null
#  person_id                :integer          not null
#  sms_id                   :integer          not null
#  check_in_uniform         :boolean
#  check_in_on_time         :boolean
#  check_in_inside_store    :boolean
#  check_out_on_time        :boolean
#  check_out_inside_store   :boolean
#  off_day                  :boolean
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  out_time                 :datetime
#  in_time                  :datetime
#  roll_call                :boolean
#  blueforce_geotag         :boolean
#  accountability_checkin_1 :boolean
#  accountability_checkin_2 :boolean
#  accountability_checkin_3 :boolean
#  sales                    :integer
#  notes                    :text
#

class SMSDailyCheck < ActiveRecord::Base

  validates :person_id, presence: true
  validates :sms_id, presence: true
  validates :date, presence: true

  belongs_to :person, class_name: 'Person', foreign_key: 'person_id'
  belongs_to :sms, class_name: 'Person', foreign_key: 'sms_id'

  def self.policy_class
    SMSDailyCheckPolicy
  end

end
