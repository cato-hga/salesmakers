# == Schema Information
#
# Table name: device_deployments
#
#  id              :integer          not null, primary key
#  device_id       :integer          not null
#  person_id       :integer          not null
#  started         :date             not null
#  ended           :date
#  tracking_number :string
#  comment         :text
#  created_at      :datetime
#  updated_at      :datetime
#

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe DeviceDeployment, :type => :model do

  it { should validate_presence_of :device }
  it { should validate_presence_of :person }
  it { should validate_presence_of :started }

end
