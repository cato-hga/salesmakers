require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe DeviceManufacturer, :type => :model do

  it { should ensure_length_of(:name).is_at_least(2) }

end
