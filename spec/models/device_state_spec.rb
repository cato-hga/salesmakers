require 'rails_helper'

RSpec.describe DeviceState, :type => :model do


  it { should ensure_length_of(:name).is_at_least(5) }

end