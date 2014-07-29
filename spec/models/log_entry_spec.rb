require 'rails_helper'

RSpec.describe LogEntry, :type => :model do

  it { should validate_presence_of(:person) }
  it { should validate_presence_of(:action) }
  it { should validate_presence_of(:trackable) }

end