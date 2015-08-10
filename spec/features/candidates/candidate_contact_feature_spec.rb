require 'rails_helper'

describe 'contacting the candidate' do
  let(:recruiter) { create :person, position: position }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_create, permission_index] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.new key: 'candidate_index',
                                          permission_group: permission_group,
                                          description: 'Test Description' }
  let(:location) { create :location }

  let!(:candidate) { create :candidate, location_area: location_area, other_phone: '8005551010' }
  let!(:location_area) { create :location_area, location: location }
  let(:note) { 'Because I feel like it' }
  let(:results) { 'The call went very well!' }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit candidates_path
    click_on 'Call'
    fill_in "Enter a note on why you are calling #{candidate.first_name}", with: note
    click_on 'Show Phone Number(s)'
  end

  it 'shows the phone numbers', js: true do
    expect(page).to have_content "(#{candidate.mobile_phone[0..2]}) #{candidate.mobile_phone[3..5]}-#{candidate.mobile_phone[6..9]}"
    expect(page).to have_content "(#{candidate.other_phone[0..2]}) #{candidate.other_phone[3..5]}-#{candidate.other_phone[6..9]}"
  end

  it 'records phone call details', js: true do
    expect(page).to have_content("(#{candidate.mobile_phone[0..2]}) #{candidate.mobile_phone[3..5]}-#{candidate.mobile_phone[6..9]}")
  end

  it 'records call results', js: true do
    fill_in "Enter the results of your call", with: results
    click_on 'Save'
    expect(page).to have_content 'Call results successfully'
    expect(page).to have_content results
  end

end