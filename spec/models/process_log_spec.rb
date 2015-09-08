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

  it 'responds to records_processed' do
    expect(subject).to respond_to(:records_processed)
  end

  it 'responds to notes' do
    expect(subject).to respond_to(:notes)
  end
end
