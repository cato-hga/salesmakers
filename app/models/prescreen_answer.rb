# == Schema Information
#
# Table name: prescreen_answers
#
#  id                           :integer          not null, primary key
#  candidate_id                 :integer          not null
#  worked_for_salesmakers       :boolean          default(FALSE), not null
#  of_age_to_work               :boolean          default(FALSE), not null
#  eligible_smart_phone         :boolean          default(FALSE), not null
#  can_work_weekends            :boolean          default(FALSE), not null
#  reliable_transportation      :boolean          default(FALSE), not null
#  ok_to_screen                 :boolean          default(FALSE), not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  worked_for_sprint            :boolean          default(FALSE), not null
#  high_school_diploma          :boolean          default(FALSE), not null
#  visible_tattoos              :boolean          default(FALSE), not null
#  worked_for_radioshack        :boolean          default(FALSE), not null
#  former_employment_date_start :date
#  former_employment_date_end   :date
#  store_number_city_state      :string
#

class PrescreenAnswer < ActiveRecord::Base

  validates :candidate_id, presence: true
  # validates :worked_for_salesmakers, presence: true
  validates :of_age_to_work, presence: true
  validates :eligible_smart_phone, presence: true
  validates :can_work_weekends, presence: true
  validates :reliable_transportation, presence: true
  validates :worked_for_sprint, presence: true
  validates :high_school_diploma, presence: true
  validates :visible_tattoos, presence: true
  validates :has_sales_experience, presence: true
  validates :sales_experience_notes, length: { minimum: 2 }

  belongs_to :candidate

  strip_attributes
end