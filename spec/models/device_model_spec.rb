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

RSpec.describe DeviceModel, :type => :model do

  it { should ensure_length_of(:name).is_at_least(3) }
  it { should validate_presence_of(:device_manufacturer) }

end
