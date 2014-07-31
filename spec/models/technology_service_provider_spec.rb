require 'rails_helper'

RSpec.describe TechnologyServiceProvider, :type => :model do

  it { should ensure_length_of(:name).is_at_least(3) }

end
