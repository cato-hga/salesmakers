# == Schema Information
#
# Table name: directv_eods
#
#  id                       :integer          not null, primary key
#  cloud_training           :boolean          default(FALSE), not null
#  cloud_training_takeaway  :text
#  directv_visit            :boolean          default(FALSE), not null
#  directv_visit_takeaway   :text
#  eod_date                 :datetime         not null
#  location_id              :integer          not null
#  person_id                :integer
#  sales_pro_visit          :boolean          default(FALSE), not null
#  sales_pro_visit_takeaway :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

class DirecTVEod < ActiveRecord::Base

  validates :location_id, presence: true
  validates :person_id, presence: true
  validates :sales_pro_visit, inclusion: { in: [true, false] }
  validates :directv_visit, inclusion: { in: [true, false] }
  validates :cloud_training, inclusion: { in: [true, false] }

  belongs_to :location
  belongs_to :person

  def self.policy_class
    DirecTVCustomerPolicy
  end
end
