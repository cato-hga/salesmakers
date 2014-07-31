require 'rails_helper'

RSpec.describe Position, :type => :model do

  it { should ensure_length_of(:name).is_at_least(5) }
  it { should validate_presence_of(:department) }
  it { should have_many(:permissions) }

end
