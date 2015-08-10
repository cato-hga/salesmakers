# == Schema Information
#
# Table name: area_types
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  project_id :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe AreaType, :type => :model do

  it { should ensure_length_of(:name).is_at_least(3) }
  it { should validate_presence_of(:project) }

  it { should belong_to(:project) }
  it { should have_many(:areas) }

  #TODO: Test default scope
end
