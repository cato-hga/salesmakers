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

require 'rails_helper'

RSpec.describe CandidateSMSMessage, :type => :model do
end
