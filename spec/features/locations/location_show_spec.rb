require 'rails_helper'

describe 'showing Locations' do
  let(:location) { create :location, channel: channel }
  let!(:area) { create :area }
  let!(:location_area) { create :location_area, location: location, area: area, target_head_count: 2, priority: 1 }
  let!(:location_candidate) { create :candidate, location_area: location_area, status: :paperwork_sent }
  let!(:candidate_job_offer_detail) { create :job_offer_detail, candidate: location_candidate, sent: Date.today }
  let(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [location_show_permission, candidate_index_permission] }
  let(:location_show_permission) { create :permission, key: 'location_show' }
  let(:candidate_index_permission) { create :permission, key: 'candidate_index' }
  let!(:channel) { create :channel }

  let!(:selected_location_candidate) { create :candidate, first_name: 'I selected this location', location_area: selected_location_area }
  let!(:inactive_candidate) { create :candidate, active: false, first_name: 'I am inactive at location', location_area: selected_location_area }

  let!(:candidate_with_hours) { create :candidate, first_name: 'I have hours here', location_area: selected_location_area }
  let!(:candidate_with_hours_person) { create :person, first_name: 'I have hours here', candidate: candidate_with_hours }
  let!(:candidate_with_hours_not_here_person) { create :person, first_name: 'No Hours Here', candidate: candidate_with_hours_not_here }
  let!(:candidate_with_hours_not_here) { create :candidate, first_name: 'No hours here', location_area: selected_location_area }
  let!(:candidate_with_old_hours) { create :candidate, first_name: 'Old Shift', location_area: selected_location_area }
  let!(:person_with_old_hours) { create :person, first_name: 'Old Shift', candidate: candidate_with_old_hours }

  let!(:old_shift) { create :shift, location: location, person: person_with_old_hours, date: (Date.today - 15.days) }
  let!(:with_hours_shift) { create :shift, location: location, person: candidate_with_hours_person, date: Date.yesterday }
  let!(:with_hours_not_here_shift) { create :shift, location: other_location, person: candidate_with_hours_not_here_person, date: Date.yesterday }

  let(:other_location) { create :location }
  let(:selected_location_area) { create :location_area, location: location }

  before do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
    visit client_project_location_path(area.project.client, area.project, location)
  end

  # I've combined the expectations to make the test faster
  it 'shows the proper fields' do
    expect(page).to have_content(channel.name)
    expect(page).to have_content(location.display_name)
    expect(page).to have_content(location.street_1)
    expect(page).to have_content(location.city)
    expect(page).to have_content(location.state)
    expect(page).to have_content(location.zip)
    expect(page).to have_content(area.name)
    expect(page).to have_content('2') # target head count
  end

  it 'shows the candidates that have this location selected' do
    within('#candidates_with_location') do
      expect(page).to have_content selected_location_candidate.name
      expect(page).not_to have_content inactive_candidate.name
    end
  end

  it 'shows the candidates that have booked hours at this location in the past two weeks' do
    within('#candidates_with_hours') do
      expect(page).to have_content candidate_with_hours.name
      expect(page).not_to have_content candidate_with_hours_not_here.name
      expect(page).not_to have_content candidate_with_old_hours.name
    end
  end

end