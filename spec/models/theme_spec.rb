require 'rails_helper'

RSpec.describe Theme, :type => :model do

  it { should ensure_length_of(:name).is_at_least(2) }
  it { should ensure_length_of(:display_name).is_at_least(2) }

end
