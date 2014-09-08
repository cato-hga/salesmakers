require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Department, :type => :model do

  it { should ensure_length_of(:name).is_at_least(5) }

  it { should have_many(:positions) }
  it { should have_many(:people).through(:positions) }
  it { should have_one(:wall) } #TODO: Test wallable?

  #TODO: Test default_scope
  #TODO: Test create_wall
end
