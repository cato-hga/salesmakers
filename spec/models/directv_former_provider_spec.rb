# == Schema Information
#
# Table name: directv_former_providers
#
#  id              :integer          not null, primary key
#  directv_sale_id :integer
#  name            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

describe DirecTVFormerProvider do
  let(:provider) { build :directv_former_provider }
  it 'is valid with correct attributes' do
    expect(provider).to be_valid
  end

  it 'requires a name' do
    provider.name = nil
    expect(provider).not_to be_valid
  end
end
