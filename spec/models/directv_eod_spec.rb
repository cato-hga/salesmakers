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

require 'rails_helper'

describe DirecTVEod do
end
