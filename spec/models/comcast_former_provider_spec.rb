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