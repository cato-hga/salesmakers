# == Schema Information
#
# Table name: technology_service_providers
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe TechnologyServiceProvider, :type => :model do

  it { should ensure_length_of(:name).is_at_least(3) }

end
