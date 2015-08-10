# == Schema Information
#
# Table name: workmarket_attachments
#
#  id                       :integer          not null, primary key
#  workmarket_assignment_id :integer          not null
#  filename                 :string           not null
#  url                      :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  guid                     :string           not null
#

require 'rails_helper'

describe WorkmarketAttachment do
  subject { build :workmarket_attachment }

  it 'requires a workmarket_assignment_id' do
    subject.workmarket_assignment_id = nil
    expect(subject).not_to be_valid
  end

  it 'requires a filename' do
    subject.filename = nil
    expect(subject).not_to be_valid
  end

  it 'requires a URL' do
    subject.url = nil
    expect(subject).not_to be_valid
  end

  it 'requires a guid' do
    subject.guid = nil
    expect(subject).not_to be_valid
  end
end
