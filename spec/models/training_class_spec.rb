# == Schema Information
#
# Table name: training_classes
#
#  id                     :integer          not null, primary key
#  training_class_type_id :integer
#  training_time_slot_id  :integer
#  date                   :datetime
#  person_id              :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

require 'rails_helper'

describe TrainingClass do
end
