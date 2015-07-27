# == Schema Information
#
# Table name: person_client_areas
#
#  id             :integer          not null, primary key
#  person_id      :integer          not null
#  client_area_id :integer          not null
#  created_at     :datetime
#  updated_at     :datetime
#

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe PersonClientArea, :type => :model do

  it { should validate_presence_of(:person) }
  it { should validate_presence_of(:client_area) }

  it { should belong_to :person }
  it { should belong_to :client_area }
end
