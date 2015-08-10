# == Schema Information
#
# Table name: comcast_eods
#
#  id                       :integer          not null, primary key
#  eod_date                 :datetime         not null
#  location_id              :integer          not null
#  sales_pro_visit          :boolean          default(FALSE), not null
#  sales_pro_visit_takeaway :text
#  comcast_visit            :boolean          default(FALSE), not null
#  comcast_visit_takeaway   :text
#  cloud_training           :boolean          default(FALSE), not null
#  cloud_training_takeaway  :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  person_id                :integer
#

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
