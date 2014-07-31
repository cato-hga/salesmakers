require 'rails_helper'

RSpec.describe PersonArea, :type => :model do

  it { should validate_presence_of(:person) }
  it { should validate_presence_of(:area) }

end
