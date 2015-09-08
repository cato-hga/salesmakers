# == Schema Information
#
# Table name: training_class_types
#
#  id             :integer          not null, primary key
#  project_id     :integer          not null
#  name           :string           not null
#  ancestry       :string
#  max_attendance :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

describe TrainingClassType do
end
