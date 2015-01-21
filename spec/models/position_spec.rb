require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Position, :type => :model do

  it { should ensure_length_of(:name).is_at_least(5) }
  it { should validate_presence_of(:department) }
  it { should have_and_belong_to_many(:permissions) }

end
