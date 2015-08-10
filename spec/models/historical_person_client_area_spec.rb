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

describe HistoricalPersonClientArea do

  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:historical_person) }
  it { should validate_presence_of(:historical_client_area) }

  it { should belong_to :historical_person }
  it { should belong_to :historical_client_area }
end
