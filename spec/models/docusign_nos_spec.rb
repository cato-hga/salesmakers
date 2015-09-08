# == Schema Information
#
# Table name: docusign_noses
#
#  id                       :integer          not null, primary key
#  person_id                :integer          not null
#  eligible_to_rehire       :boolean          default(FALSE), not null
#  termination_date         :datetime
#  last_day_worked          :datetime
#  employment_end_reason_id :integer
#  remarks                  :text
#  envelope_guid            :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  third_party              :boolean          default(FALSE), not null
#  manager_id               :integer
#

require 'rails_helper'

describe DocusignNos do
end
