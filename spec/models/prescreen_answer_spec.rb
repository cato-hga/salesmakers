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

require 'rails_helper'

describe PrescreenAnswer do
end
