require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe DeviceDeployment, :type => :model do

  it { should validate_presence_of :device }
  it { should validate_presence_of :person }
  it { should validate_presence_of :started }

end