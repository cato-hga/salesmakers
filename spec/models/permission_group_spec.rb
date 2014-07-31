require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe PermissionGroup, :type => :model do

  it { should ensure_length_of(:name).is_at_least(3) }

end
