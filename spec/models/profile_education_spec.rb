require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe ProfileEducation, :type => :model do

  it { should belong_to :profile }
end

