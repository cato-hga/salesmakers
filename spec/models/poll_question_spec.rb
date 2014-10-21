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

  let(:question_ending_before_start) {
    build :poll_question,
          start_time: Time.now + 1.day,
          end_time: Time.now + 1.minute
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
  specify { expect(subject).to respond_to(:poll_question_choices) }

  it 'does not allow a start time before today' do
    expect(question_starting_yesterday).not_to be_valid
  end

  it 'does not allow an end time before now' do
    expect(question_ending_in_past).not_to be_valid
  end

  it 'allows an existing question to start in the past' do
    subject.save
    subject.start_time = Time.now - 1.day
    expect(subject).to be_valid
  end

  it 'does not allow a question to end before it starts' do
    expect(question_ending_before_start).not_to be_valid
  end

  it 'returns a nil help text value for empty strings' do
    subject.help_text = ''
    subject.save
    subject.reload
    expect(subject.help_text).to be_nil
  end

  context 'with a poll question choice that has been answered' do
    let!(:poll_question_choice) { create :poll_question_choice }

    it 'reflects as locked' do
      person = Person.first
      poll_question_choice.people << person
      expect(poll_question_choice.poll_question.locked?).to be_truthy
    end

    it 'reflects the correct number of answers' do
      poll_question = poll_question_choice.poll_question
      second_poll_question_choice = create :poll_question_choice,
                                           name: 'Another choice',
                                           poll_question_id: poll_question.id
      person = Person.first
      second_person = create :person
      poll_question_choice.people << person
      second_poll_question_choice.people << person
      second_poll_question_choice.people << second_person
      expect(poll_question.answers).to eq(3)
    end
  end

  context 'with no answered poll question choices' do
    it 'does not reflect as locked' do
      expect(subject.locked?).to be_falsey
    end
  end

end