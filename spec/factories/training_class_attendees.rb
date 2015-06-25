# == Schema Information
#
# Table name: training_class_attendees
#
#  id                         :integer          not null, primary key
#  person_id                  :integer          not null
#  training_class_id          :integer          not null
#  attended                   :boolean          default(FALSE), not null
#  dropped_off_time           :datetime
#  drop_off_reason_id         :integer
#  status                     :integer          not null
#  conditional_pass_condition :text
#  group_me_setup             :boolean          default(FALSE), not null
#  time_clock_setup           :boolean          default(FALSE), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

FactoryGirl.define do
  factory :training_class_attendee do
    association :person
    association :training_class
  end
end
