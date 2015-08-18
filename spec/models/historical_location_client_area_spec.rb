# == Schema Information
#
# Table name: historical_location_client_areas
#
#  id                        :integer          not null, primary key
#  historical_location_id    :integer          not null
#  historical_client_area_id :integer          not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  date                      :date             not null
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
