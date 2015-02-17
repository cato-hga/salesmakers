require 'rails_helper'

describe VonageProduct do
  subject(:vonage_product) { build :vonage_product }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a name' do
    subject.name = nil
    expect(subject).not_to be_valid
  end

end