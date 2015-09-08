# == Schema Information
#
# Table name: communication_log_entries
#
#  id            :integer          not null, primary key
#  loggable_id   :integer          not null
#  loggable_type :string           not null
#  created_at    :datetime
#  updated_at    :datetime
#  person_id     :integer          not null
#

require 'rails_helper'

describe CommunicationLogEntry do
end
