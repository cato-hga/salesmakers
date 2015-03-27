require 'rails_helper'

describe '(Re)sending paperwork for confirmed candidates' do

  let!(:candidate) { create :candidate }
  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission, permission_two] }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_two) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }

  context 'for qualified candidates' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      candidate.personality_assessment_score = 45
      candidate.personality_assessment_status = 'qualified'
      candidate.confirmed!
      candidate.reload
      visit candidate_path(candidate)
    end

    it 'the candidate show page has a the option to send paperwork' do
      expect(page).to have_content 'Send or Resend Paperwork'
    end

    it 'sends the paperwork when clicked' do
      click_on 'Send or Resend Paperwork'
      expect(page).to have_content('Paperwork Sent')
      expect(JobOfferDetail.count).to eq(1)
    end

    it 'redirects to candidate#show and does not show the button once the paperwork is sent' do
      click_on 'Send or Resend Paperwork'
      expect(page).not_to have_content 'Send or Resend Paperwork'
    end
  end

  context 'for unqualified candidates' do
    it 'does not show the button' do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      candidate.confirmed!
      visit candidate_path(candidate)
      expect(page).not_to have_content 'Send or Resend Paperwork'
    end
  end

end