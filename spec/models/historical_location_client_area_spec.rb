# == Schema Information
#
# Table name: location_client_areas
#
#  id             :integer          not null, primary key
#  location_id    :integer          not null
#  client_area_id :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

require 'rails_helper'

describe HistoricalLocationClientArea do
  subject { build :historical_location_client_area }

  it 'does not allow duplicates' do
    subject.save
    duplicate = subject.dup
    expect(duplicate).not_to be_valid
  end
end
