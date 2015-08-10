# == Schema Information
#
# Table name: process_logs
#
#  id                :integer          not null, primary key
#  process_class     :string           not null
#  records_processed :integer          default(0), not null
#  notes             :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'rails_helper'

describe ProcessLog do
  subject { build :process_log }

  it 'is valid with proper attributes' do
    expect(subject).to be_valid
  end

  it 'requires a process_class' do
    subject.process_class = nil
    expect(subject).not_to be_valid
  end

  it 'responds to records_processed' do
    expect(subject).to respond_to(:records_processed)
  end

  it 'responds to notes' do
    expect(subject).to respond_to(:notes)
  end
end
