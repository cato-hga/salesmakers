# == Schema Information
#
# Table name: permission_groups
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe PermissionGroup, :type => :model do

  it { should ensure_length_of(:name).is_at_least(3) }

  it { should have_many :permissions }
end
