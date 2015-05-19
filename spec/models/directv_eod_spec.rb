require 'rails_helper'

describe DirecTVEod do
  subject { build :directv_eod }

  it 'is valid with correct attributes' do
    expect(subject).to be_valid
  end

  it 'requires a person id' do
    subject.person_id = nil
    expect(subject).not_to be_valid
  end

  it 'requires a location' do
    subject.location = nil
    expect(subject).not_to be_valid
  end

  it 'requires a sales pro visit decision' do
    subject.sales_pro_visit = nil
    expect(subject).not_to be_valid
  end

  it 'requires a directv visit decision' do
    subject.directv_visit = nil
    expect(subject).not_to be_valid
  end

  it 'requires a cloud training decision' do
    subject.cloud_training = nil
    expect(subject).not_to be_valid
  end
end