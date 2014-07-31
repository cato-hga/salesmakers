require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe DeviceModel, :type => :model do

  it { should ensure_length_of(:name).is_at_least(5) }
  it { should validate_presence_of(:device_manufacturer) }

end
