require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe PersonArea, :type => :model do

  it { should validate_presence_of(:person) }
  it { should validate_presence_of(:area) }

end
