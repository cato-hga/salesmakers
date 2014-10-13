require 'rails_helper'
require 'shoulda/matchers'

describe PollQuestionChoice do

  subject { build :poll_question_choice }

  it { should validate_presence_of(:poll_question) }
  it { should ensure_length_of(:name).is_at_least(2) }
  specify { expect(subject).to respond_to(:help_text) }
end