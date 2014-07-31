require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Device, :type => :model do

  it { should ensure_length_of(:identifier).is_at_least(4) }
  it { should ensure_length_of(:serial).is_at_least(6) }
  it { should validate_presence_of(:device_model) }

end