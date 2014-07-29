require 'rails_helper'

RSpec.describe AreaType, :type => :model do

  it { should ensure_length_of(:name).is_at_least(3) }
  it { should validate_presence_of(:project) }

end
