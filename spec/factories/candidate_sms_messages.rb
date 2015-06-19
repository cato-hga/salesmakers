# == Schema Information
#
# Table name: candidate_sms_messages
#
#  id         :integer          not null, primary key
#  text       :string           not null
#  active     :boolean          default(TRUE), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :candidate_sms_message do
    text 'This is a text that is 160 characters long, so its going to go on and on and on and on and on and on and on and on and on and on and on and on and then just en'
  end
end
