# == Schema Information
#
# Table name: person_areas
#
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  area_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#  manages    :boolean          default(FALSE), not null
#

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe PersonArea, :type => :model do

  it { should validate_presence_of(:person) }
  it { should validate_presence_of(:area) }

  it { should belong_to :person }
  it { should belong_to :area }
end
