require 'rails_helper'

describe 'candidate index' do
  let!(:candidate) { create :candidate, location_area: location_area, created_by: recruiter }
  let!(:recruiter) { create :person, last_name: 'Recruiter', position: position }
  let(:position) { create :position, permissions: [permission] }
  let!(:location_area) { create :location_area }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit candidates_path
  end

  it 'should have the correct title' do
    expect(page).to have_content('Candidates')
  end

  it 'should show the candidate on the index page' do
    expect(page).to have_content(candidate.name)
  end

  it 'shows the person who entered the candidate' do
    expect(page).to have_content(recruiter.display_name)
  end

  it 'shows the preassessment status of the candidate' do
    expect(page).to have_content('Assessment')
    expect(page).to have_content('Incomplete')
  end

  it 'searches for first names' do
    fill_in 'q_first_name_cont', with: candidate.first_name[3]
    within '#main_container' do
      find('input[value="Search"]').click
    end
    expect(page).to have_content(candidate.name)
  end

  it 'searches for last names' do
    fill_in 'q_last_name_cont', with: candidate.last_name[3]
    within '#main_container' do
      find('input[value="Search"]').click
    end
    expect(page).to have_content(candidate.name)
  end

  it 'searches for mobile numbers' do
    fill_in 'q_mobile_phone_number_cont', with: candidate.mobile_phone[3]
    within '#main_container' do
      find('input[value="Search"]').click
    end
    expect(page).to have_content(candidate.name)
  end

  it 'searches for email' do
    fill_in 'q_email_cont', with: candidate.email[5]
    within '#main_container' do
      find('input[value="Search"]').click
    end
    expect(page).to have_content(candidate.name)
  end

  it 'searches for ZIP codes' do
    fill_in 'q_zip_cont', with: candidate.zip
    within '#main_container' do
      find('input[value="Search"]').click
    end
    expect(page).to have_content(candidate.name)
  end

  it 'searches for projects' do
    fill_in 'q_location_area_area_project_name_cont', with: location_area.area.project.name[4]
    within '#main_container' do
      find('input[value="Search"]').click
    end
    expect(page).to have_content(candidate.name)
  end

  it 'searches for channels' do
    fill_in 'q_location_area_location_channel_name_cont', with: location_area.location.channel.name[3]
    within '#main_container' do
      find('input[value="Search"]').click
    end
    expect(page).to have_content(candidate.name)
  end

  it 'searches for locations' do
    fill_in 'q_location_area_location_display_name_cont', with: location_area.location.display_name[3]
    within '#main_container' do
      find('input[value="Search"]').click
    end
    expect(page).to have_content(candidate.name)
  end

  it "visits a candidate's show page" do
    click_on candidate.name
    expect(page).to have_content(location_area.location.address)
  end

  it 'shows the proper title for a search for candidate source' do
    source = create :candidate_source
    select source.name, from: 'q_candidate_source_id_eq'
    within '.candidate_search' do
      click_on 'Search'
    end
    expect(page).to have_content "#{source.name} Candidates"
  end
end