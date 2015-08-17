require 'rails_helper'

describe 'candidate show page' do

  let!(:candidate) {
    create :candidate,
           location_area: location_area,
           personality_assessment_score: 45,
           personality_assessment_status: :qualified,
           training_availability: training_availability,
           candidate_availability: candidate_availability,
           sprint_roster_status: :sprint_confirmed }

  let!(:recruiter) { create :person, position: position }
  let(:position) { create :position, permissions: [permission] }
  let!(:location_area) { create :location_area, location: location }
  let(:location) { create :location, sprint_radio_shack_training_location: training_location }
  let(:training_location) { create :sprint_radio_shack_training_location, latitude: 40, longitude: 50 }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  let!(:candidate_contact) {
    create :candidate_contact,
           candidate: candidate,
           person: recruiter,
           contact_method: :phone,
           notes: 'This is a sample note'
  }
  let!(:interview) { create :interview_schedule, person: recruiter, candidate: candidate, start_time: (Time.zone.now + 1.day) }
  let!(:interview_answer) { create :interview_answer, candidate: candidate }
  let(:training_availability) { create :training_availability }
  let(:candidate_availability) { create :candidate_availability }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit candidate_path(candidate)
  end


  it 'has a dismissal button' do
    expect(page).to have_content 'Dismiss Candidate'
  end

  it 'should have the proper page title' do
    expect(page).to have_selector('h1', text: candidate.name)
  end

  it 'should show states of completion' do
    expect(page).to have_content('INCOMPLETE')
  end

  it 'should show the contact log' do
    expect(page).to have_content(candidate_contact.notes)
  end

  it 'shows the call button' do
    expect(page).to have_selector 'a', text: 'Call'
  end

  it 'shows the call button when at least one number is valid' do
    candidate.update other_phone: '9194445366', mobile_phone_valid: false, other_phone_valid: true
    visit candidate_path(candidate)
    expect(page).to have_selector 'a', text: 'Call'
  end

  it 'shows the text message icon link' do
    expect(page).to have_selector 'a i.fi-megaphone'
  end

  it 'does not show the text message icon link if the mobile phone number is not valid' do
    candidate.update mobile_phone_valid: false
    visit candidate_path(candidate)
    expect(page).not_to have_selector 'a i.fi-megaphone'
  end

  it 'does not show the text message icon link if the mobile phone number is a landline' do
    candidate.update mobile_phone_is_landline: true
    visit candidate_path(candidate)
    expect(page).not_to have_selector 'a i.fi-megaphone'
  end

  it 'does not show the call button when both phone numbers are invalid' do
    candidate.update other_phone: '9194445366', mobile_phone_valid: false, other_phone_valid: false
    visit candidate_path(candidate)
    expect(page).not_to have_selector 'a', text: 'Call'
  end

  it 'shows the scheduled interview time' do
    expect(page).to have_content(interview.start_time.strftime('%m/%d %l:%M%P %Z'))
  end

  it 'shows the personality assessment score' do
    expect(page).to have_content('45')
  end

  it 'shows the personality assessment status' do
    within '#basic_information' do
      expect(page).to have_selector('.sm_green', text: 'Qualified')
    end
  end

  it 'shows the candidate availability' do
    expect(page).to have_content('Availability')
  end

  it 'has an edit button for candidate availability' do
    within('.widget.availability') do
      expect(page).to have_content ('Edit')
    end
  end

  it 'shows the candidates details' do
    expect(page).to have_content('Candidate Details')
  end

  it 'shows the candidates interview answers' do
    expect(page).to have_content('Candidate Interview Answers')
  end

  it 'shows the candidate ID' do
    expect(page).to have_content candidate.id
  end

  it 'has an edit button for details' do
    within('.widget.candidate_details') do
      expect(page).to have_content ('Edit')
    end
  end

  it 'does not show the training session form for those without permission' do
    expect(page).not_to have_selector('#new_sprint_radio_shack_training_session')
  end

  it 'has a link to the candidates selected location if applicable' do
    expect(page).to have_content('Candidate Location')
  end

  context 'training sessions' do
    let(:view_all) { view_all = create :permission, key: 'candidate_view_all' }
    let!(:training_session) { create :sprint_radio_shack_training_session }
    let!(:status) { 'Candidate Confirmed' }
    before(:each) do
      recruiter.position.permissions << view_all
      recruiter.reload
      visit candidate_path(candidate)
    end
    it 'allows the training session to be set for those with permission' do
      within '#new_sprint_radio_shack_training_session' do
        select training_session.name, from: 'sprint_radio_shack_training_session_id'
        click_on 'Save'
      end
      candidate.reload
      expect(candidate.sprint_radio_shack_training_session.name).to eq(training_session.name)
    end

    it 'allows the training session status to be set for those with permission' do
      within '#training_status' do
        select status, from: 'training_session_status'
        click_on 'Save'
        candidate.reload
        expect(candidate.training_session_status).to eq('candidate_confirmed')
      end
    end
  end

  context 'hours widget' do
    let!(:person) { create :person }
    let!(:working_candidate) { create :candidate, person: person }
    let!(:location) { create :location }
    let!(:last_location) { create :location, display_name: 'The Latest Location' }
    let!(:first_shift) { create :shift, person: person, date: Date.today - 8.days, hours: 8, location: location }
    let!(:second_shift) { create :shift, person: person, date: Date.today - 6.days, hours: 5, location: location }
    let!(:third_shift) { create :shift, person: person, date: Date.today - 2.days, hours: 6, location: last_location }
    it 'does not show the hours widget if the candidate does not have a person' do
      #inheriting the visit
      expect(page).not_to have_css('#candidate_hours')
    end
    it 'shows the total hours, last shift, and location for candidates' do
      visit candidate_path(working_candidate)
      within('#candidate_hours') do
        expect(page).to have_content 'Total Hours: 19.0'
        expect(page).to have_content 'Hours This Week: 11.0'
        expect(page).to have_content "Last Shift Date: #{third_shift.date.strftime('%A, %b %e')}"
        expect(page).to have_content "Last Shift Location: ##{third_shift.location.store_number} (#{third_shift.location.channel.name}), #{third_shift.location.street_1}, #{third_shift.location.city}, #{third_shift.location.state}"
      end
    end
  end

  context 'NHP LogEntry' do
    let!(:job_offer_detail) { create :job_offer_detail, candidate: candidate }
    let!(:log_entry_candidate) { create :log_entry, action: 'signed_nhp', trackable: job_offer_detail, referenceable: candidate, comment: 'Candidate' }
    let!(:log_entry_advocate) { create :log_entry, action: 'signed_nhp', trackable: job_offer_detail, referenceable: candidate, comment: 'Advocate' }
    let!(:log_entry_hr) { create :log_entry, action: 'signed_nhp', trackable: job_offer_detail, referenceable: candidate, comment: 'HR' }

    it 'shows the log entries' do
      visit candidate_path(candidate)
      expect(page).to have_content('NHP signed by Candidate')
      expect(page).to have_content('NHP signed by Advocate')
      expect(page).to have_content('NHP signed by HR')
    end
  end
end
