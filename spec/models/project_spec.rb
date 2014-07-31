require 'rails_helper'

RSpec.describe Project, :type => :model do

  it { should ensure_length_of(:name).is_at_least(4) }
  it { should validate_presence_of(:client) }

end
