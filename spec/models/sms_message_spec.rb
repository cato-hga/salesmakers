# == Schema Information
#
# Table name: sms_messages
#
#  id                      :integer          not null, primary key
#  from_num                :string           not null
#  to_num                  :string           not null
#  from_person_id          :integer
#  to_person_id            :integer
#  inbound                 :boolean          default(FALSE)
#  reply_to_sms_message_id :integer
#  replied_to              :boolean          default(FALSE)
#  message                 :text             not null
#  created_at              :datetime
#  updated_at              :datetime
#  sid                     :string           not null
#  from_candidate_id       :integer
#  to_candidate_id         :integer
#

require 'rails_helper'

describe SMSMessage do
end
