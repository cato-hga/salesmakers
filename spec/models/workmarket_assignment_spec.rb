# == Schema Information
#
# Table name: workmarket_assignments
#
#  id                        :integer          not null, primary key
#  project_id                :integer          not null
#  json                      :text             not null
#  workmarket_assignment_num :string           not null
#  title                     :string           not null
#  worker_name               :string           not null
#  worker_first_name         :string
#  worker_last_name          :string
#  worker_email              :string           not null
#  cost                      :float            not null
#  started                   :datetime         not null
#  ended                     :datetime         not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  workmarket_location_num   :string           not null
#

require 'rails_helper'

describe WorkmarketAssignment do
  subject { build :workmarket_assignment }

  it 'responds to worker_first_name' do
    expect(subject).to respond_to(:worker_first_name)
  end

  it 'responds to worker_last_name' do
    expect(subject).to respond_to(:worker_last_name)
  end

  it 'requires a worker_email' do
    subject.worker_email = nil
    expect(subject).not_to be_valid
  end

  it 'retrieves a list of client assignments' do
    subject.save
    expect(WorkmarketAssignment.for_client(subject.project.client).count).to eq(1)
  end
end
