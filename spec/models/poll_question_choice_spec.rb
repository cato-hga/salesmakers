require 'rails_helper'
require 'shoulda/matchers'

describe PollQuestionChoice do

  subject { build :poll_question_choice }

  it { should validate_presence_of(:poll_question) }
  it { should ensure_length_of(:name).is_at_least(2) }
  specify { expect(subject).to respond_to(:help_text) }

  it 'should return a nil help text value for empty strings' do
    subject.help_text = ''
    subject.save
    subject.reload
    expect(subject.help_text).to be_nil
  end

  context 'with at least one answer' do
    let(:person) { create :person }
    let(:admin_person) { create :it_tech_person }

    before do
      subject.save
      subject.people << admin_person
    end

    it 'should reflect as locked' do
      expect(subject.locked?).to be_truthy
    end

    it 'should reflect the correct number of answers' do
      subject.people << person
      expect(subject.answers).to eq(2)
    end

    it 'knows whether a choice has been answered by a particular person' do
      subject.people << person
      expect(subject.answered_by?(person)).to be_truthy
    end
  end

  context 'without an answer' do
    it 'should reflect as not locked' do
      subject.save
      expect(subject.locked?).to be_falsey
    end
  end
end