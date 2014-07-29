require 'rails_helper'

RSpec.describe Permission, :type => :model do


  it { should ensure_length_of(:key).is_at_least(5) }
  it { should ensure_length_of(:description).is_at_least(10) }
  it { should validate_presence_of(:permission_group) }

end
