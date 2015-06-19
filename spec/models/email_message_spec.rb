# == Schema Information
#
# Table name: email_messages
#
#  id           :integer          not null, primary key
#  from_email   :string           not null
#  to_email     :string           not null
#  to_person_id :integer
#  content      :text             not null
#  created_at   :datetime
#  updated_at   :datetime
#  subject      :string           not null
#

require 'rails_helper'

describe EmailMessage do
  subject { build :email_message }

  it 'is valid with all required attributes' do
    expect(subject).to be_valid
  end

  it 'requires a from_email address' do
    subject.from_email = nil
    expect(subject).not_to be_valid
  end

  it 'requires a to_email address' do
    subject.to_email = nil
    expect(subject).not_to be_valid
  end

  it 'requires a subject' do
    subject.subject = nil
    expect(subject).not_to be_valid
  end

  it 'requires content' do
    subject.content = nil
    expect(subject).not_to be_valid
  end

  describe 'saving to_person_id' do
    let!(:person) { create :person, personal_email: '123@fourfivesix.com' }

    specify 'when email is recognized' do
      subject.to_email = person.email
      expect(subject.to_person).to eq(person)
    end

    specify 'when personal email is recognized' do
      subject.to_email = person.personal_email
      expect(subject.to_person).to eq(person)
    end

    specify 'when no email is recognized, does not save' do
      subject.to_email = 'bleh@blahblah.com'
      expect(subject.to_person).to be_nil
    end
  end
end
