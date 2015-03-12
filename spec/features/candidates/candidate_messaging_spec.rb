require 'rails_helper'

describe 'Sending a message to a candidate' do
  let!(:message) { create :candidate_sms_message }
  let!(:candidate) { create :candidate, mobile_phone: '8137164150' }
  let!(:recruiter) { create :person, position: recruiter_position }
  let(:recruiter_position) { create :position, name: 'Advocate', permissions: [permission_create, permission_index], hq: true }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'candidate_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  it 'sends an SMS message', :vcr do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit candidates_path
    find('a.send_contact').click
    select message.text, from: 'contact_message'
    click_on 'Send'
    visit candidate_path(candidate)
    expect(page).to have_content(message.text)
  end
end
