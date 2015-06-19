# == Schema Information
#
# Table name: comcast_eods
#
#  id                       :integer          not null, primary key
#  eod_date                 :datetime         not null
#  location_id              :integer          not null
#  sales_pro_visit          :boolean          default(FALSE), not null
#  sales_pro_visit_takeaway :text
#  comcast_visit            :boolean          default(FALSE), not null
#  comcast_visit_takeaway   :text
#  cloud_training           :boolean          default(FALSE), not null
#  cloud_training_takeaway  :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  person_id                :integer
#

class ComcastEod < ActiveRecord::Base

  validates :location_id, presence: true
  validates :person_id, presence: true
  validates :sales_pro_visit, inclusion: {in: [true, false]}
  validates :comcast_visit, inclusion: {in: [true, false]}
  validates :cloud_training, inclusion: {in: [true, false]}

  belongs_to :location
  belongs_to :person

  def self.policy_class
    ComcastCustomerPolicy
  end
end
