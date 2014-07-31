require 'rails_helper'

RSpec.describe Area, :type => :model do

  it { should ensure_length_of(:name).is_at_least(3) }
  it { should validate_presence_of(:area_type) }

end
