# == Schema Information
#
# Table name: interview_schedules
#
#  id             :integer          not null, primary key
#  candidate_id   :integer          not null
#  person_id      :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  interview_date :date
#  start_time     :datetime         not null
#  active         :boolean
#

require 'rails_helper'

describe InterviewSchedule do
end
