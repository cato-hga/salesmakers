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

  describe 'validations' do
    let(:message) { build :candidate_sms_message }

    it 'cannot be above 160 characters long' do
      message.text = 'this is a text that is 160 characters long, so its going to go on and on and on and on and on and on and on and on and on and on and on and on and then just endd'
      expect(message).not_to be_valid
    end
    it 'requires text' do
      message.text = nil
      expect(message).not_to be_valid
    end
  end
end
