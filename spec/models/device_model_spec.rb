# == Schema Information
#
# Table name: device_models
#
#  id                     :integer          not null, primary key
#  name                   :string           not null
#  device_manufacturer_id :integer          not null
#  created_at             :datetime
#  updated_at             :datetime
#

require 'rails_helper'
require 'shoulda/matchers'

describe DeviceModel do
end
