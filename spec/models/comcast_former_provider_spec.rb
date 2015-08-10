# == Schema Information
#
# Table name: comcast_former_providers
#
#  id              :integer          not null, primary key
#  name            :string           not null
#  comcast_sale_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

describe ComcastFormerProvider do
  let(:provider) { build :comcast_former_provider }
  it 'is valid with correct attributes' do
    expect(provider).to be_valid
  end

  it 'requires a name' do
    provider.name = nil
    expect(provider).not_to be_valid
  end
end
