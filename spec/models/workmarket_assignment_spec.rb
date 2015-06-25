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

  it 'requires a project' do
    subject.project = nil
    expect(subject).not_to be_valid
  end

  it 'requires json' do
    subject.json = nil
    expect(subject).not_to be_valid
  end

  it 'requires a workmarket_assignment_num' do
    subject.workmarket_assignment_num = nil
    expect(subject).not_to be_valid
  end

  it 'requires a title' do
    subject.title = nil
    expect(subject).not_to be_valid
  end

  it 'requires a worker_name' do
    subject.worker_name = nil
    expect(subject).not_to be_valid
  end

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

  it 'requires a cost' do
    subject.cost = nil
    expect(subject).not_to be_valid
  end

  it 'requires the cost be above zero' do
    subject.cost = -1.0
    expect(subject).not_to be_valid
  end

  it 'requires a started datetime' do
    subject.started = nil
    expect(subject).not_to be_valid
  end

  it 'requires a ended datetime' do
    subject.ended = nil
    expect(subject).not_to be_valid
  end

  it 'requires a workmarket_location_num' do
    subject.workmarket_location_num = nil
    expect(subject).not_to be_valid
  end

  it 'retrieves a list of client assignments' do
    subject.save
    expect(WorkmarketAssignment.for_client(subject.project.client).count).to eq(1)
  end
end
