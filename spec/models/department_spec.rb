require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Department, :type => :model do

  it { should ensure_length_of(:name).is_at_least(5) }

end
