# == Schema Information
#
# Table name: directv_eods
#
#  id                       :integer          not null, primary key
#  cloud_training           :boolean          default(FALSE), not null
#  cloud_training_takeaway  :text
#  directv_visit            :boolean          default(FALSE), not null
#  directv_visit_takeaway   :text
#  eod_date                 :datetime         not null
#  location_id              :integer          not null
#  person_id                :integer
#  sales_pro_visit          :boolean          default(FALSE), not null
#  sales_pro_visit_takeaway :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

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
