require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Answer, :type => :model do

  it { should belong_to(:person) }
  it { should belong_to(:question) }
  it { should have_many(:answer_upvotes) }
end
