# == Schema Information
#
# Table name: workmarket_locations
#
#  id                      :integer          not null, primary key
#  workmarket_location_num :string           not null
#  name                    :string           not null
#  location_number         :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

require 'rails_helper'

describe WorkmarketLocation do
  subject { build :workmarket_location }

  it 'responds to location_number' do
    expect(subject).to respond_to(:location_number)
  end
end
