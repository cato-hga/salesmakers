require 'rails_helper'
require 'shoulda/matchers'

describe PollQuestionChoice do

  subject { build :poll_question_choice }

  it { should validate_presence_of(:poll_question) }
  it { should ensure_length_of(:name).is_at_least(2) }
  specify { expect(subject).to respond_to(:help_text) }

  context 'with at least one answer' do
    it 'should reflect as locked' do
      subject.save
      person = Person.first
      subject.people << person
      expect(subject.locked?).to be_truthy
    end
  end

  context 'without an answer' do
    it 'should reflect as not locked' do
      subject.save
      expect(subject.locked?).to be_falsey
    end
  end
end