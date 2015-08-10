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

FactoryGirl.define do
  factory :comcast_eod do
    person
    eod_date DateTime.now
    location
    sales_pro_visit false
    comcast_visit false
    cloud_training false
  end
end
