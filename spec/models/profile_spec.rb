require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Profile, :type => :model do

  it { should validate_presence_of(:person) }

end
