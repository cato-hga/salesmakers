require 'rails_helper'

RSpec.describe Profile, :type => :model do

  it { should validate_presence_of(:person) }

end
