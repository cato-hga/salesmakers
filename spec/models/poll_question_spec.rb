require 'rails_helper'
require 'shoulda/matchers'

describe PollQuestion do

  let(:question_starting_yesterday) {
    build :poll_question,
                  start_time: Time.now.beginning_of_day - 1.second
  }

  let(:question_ending_in_past) {
    build :poll_question,
                  end_time: Time.now - 1.second
  }

  subject { build :poll_question }

  it 'is valid in its initial state' do
    expect(subject).to be_valid
  end

  it { should ensure_length_of(:question).is_at_least(15) }
  specify { expect(subject).to respond_to(:help_text) }
  it { should validate_presence_of(:start_time) }
  specify { expect(subject).to respond_to(:end_time) }
  specify { expect(subject).to respond_to(:active) }

  it 'allows a start time before today' do
    expect(question_starting_yesterday).not_to be_valid
  end

  it 'allows an end time before now' do
    expect(question_ending_in_past).not_to be_valid
  end

  it 'allows an existing question to start in the past' do
    subject.save
    subject.start_time = Time.now - 1.day
    expect(subject).to be_valid
  end

end