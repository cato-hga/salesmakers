require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Publication, :type => :model do

  it { should belong_to :publishable }
  #TODO: Test publish
end
