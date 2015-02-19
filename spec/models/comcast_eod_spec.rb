require 'rails_helper'

describe ComcastEod do
  subject { build :comcast_eod }

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

  it 'requires a comcast visit decision' do
    subject.comcast_visit = nil
    expect(subject).not_to be_valid
  end

  it 'requires a cloud training decision' do
    subject.cloud_training = nil
    expect(subject).not_to be_valid
  end
end