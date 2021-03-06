require 'rails_helper'

describe 'SMS (support) index' do
  let!(:candidate) {
    create :candidate,
           location_area: location_area,
           created_by: recruiter,
           status: :paperwork_completed_by_advocate,
           shirt_gender: 'Male',
           shirt_size: 'L',
           sprint_radio_shack_training_session: sprint_radio_shack_training_session
  }
  let!(:candidate_availability) {
    create :candidate_availability,
           candidate: candidate,
           tuesday_first: true,
           tuesday_second: true,
           tuesday_third: true

  }
  let!(:recruiter) { create :person, last_name: 'Recruiter', position: position }
  let(:position) { create :position, permissions: [permission_index, permission_view_all] }
  let!(:location_area) { create :location_area }
  let(:permission_group) { PermissionGroup.create name: 'Candidates' }
  let(:permission_index) { Permission.create key: 'candidate_index', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_view_all) { Permission.create key: 'candidate_view_all', description: 'Blah blah blah', permission_group: permission_group }
  let!(:training_availability) { create :training_availability, candidate: candidate }
  let!(:sprint_radio_shack_training_session) { create :sprint_radio_shack_training_session }

  before do
    CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
    visit support_search_candidates_path
  end

  it 'should have the correct title' do
    expect(page).to have_content('Candidate Support Search')
  end

  it 'should have the candidate name' do
    expect(page).to have_content(candidate.name)
  end

  it 'should have the candidate email' do
    expect(page).to have_selector('a', text: candidate.email)
  end

  it "should have the candidate's shirt size" do
    expect(page).to have_content("#{candidate.shirt_gender} #{candidate.shirt_size}")
  end

  it 'should indicate whether the candidate can attend training' do
    expect(page).to have_content('Yes')
  end

  it "should have the candidate's availability" do
    expect(page).to have_content('MAE')
  end

  it "should have the candidate's area" do
    expect(page).to have_content(location_area.area.name)
  end

  it "should have the candidate's location" do
    expect(page).to have_content(location_area.location.city)
    expect(page).to have_content(location_area.location.display_name)
  end

  it "should have the candidate's status" do
    expect(page).to have_content("Paperwork Completed By Advocate")
  end

  it "should have a call button" do
    expect(page).to have_selector('a', text: 'Call')
  end

  it "should not have the regular candidate search bar" do
    expect(page).not_to have_selector('#q_created_by_display_name_cont')
  end

  # describe 'the SalesMakers Support Filter' do
  #   let!(:non_filtered_candidate) { create :candidate,
  #                                          first_name: 'Test 2',
  #                                          location_area: location_area,
  #                                          created_by: recruiter,
  #                                          status: :paperwork_completed_by_candidate,
  #                                          shirt_gender: 'Male',
  #                                          shirt_size: 'L'
  #   }
  #   let!(:other_non_filtered_candidate) { create :candidate,
  #                                                first_name: 'Test 3',
  #                                                location_area: location_area,
  #                                                created_by: recruiter,
  #                                                status: :paperwork_sent,
  #                                                shirt_gender: 'Male',
  #                                                shirt_size: 'L'
  #   }
  #   let!(:filtered_candidate) { create :candidate,
  #                                      first_name: 'Test 4',
  #                                      location_area: location_area,
  #                                      created_by: recruiter,
  #                                      status: :paperwork_completed_by_hr,
  #                                      shirt_gender: 'Male',
  #                                      shirt_size: 'L'
  #   }
  #   let!(:other_filtered_candidate) { create :candidate,
  #                                            first_name: 'Test 5',
  #                                            location_area: location_area,
  #                                            created_by: recruiter,
  #                                            status: :fully_screened,
  #                                            shirt_gender: 'Male',
  #                                            shirt_size: 'L'
  #   }
  #
  #   it 'shows the non filtered candidates on the normal view' do
  #     visit support_search_candidates_path
  #     expect(page).to have_content(non_filtered_candidate.name)
  #     expect(page).to have_content(other_non_filtered_candidate.name)
  #     expect(page).to have_content(candidate.name)
  #     expect(page).to have_content(filtered_candidate.name)
  #     expect(page).to have_content(other_filtered_candidate.name)
  #   end

  #   it 'filters out candidates without candidate paperwork completed by advocate or above' do
  #     within('.candidate_search') do
  #       find('#q_status_gteq').set('Enable')
  #       click_on 'Search'
  #     end
  #     sleep 1.0
  #     expect(page).not_to have_content(non_filtered_candidate.name)
  #     expect(page).not_to have_content(other_non_filtered_candidate.name)
  #     expect(page).to have_content(candidate.name)
  #     expect(page).to have_content(filtered_candidate.name)
  #     expect(page).to have_content(other_filtered_candidate.name)
  #   end
  #
  #   it 'the disable button readds candidates otherwise filtered' do
  #     find('#q_status_gteq').set('Enable')
  #     click_on 'Search'
  #     expect(page).not_to have_content(non_filtered_candidate.name)
  #     expect(page).not_to have_content(other_non_filtered_candidate.name)
  #     expect(page).to have_content(candidate.name)
  #     expect(page).to have_content(filtered_candidate.name)
  #     expect(page).to have_content(other_filtered_candidate.name)
  #     find('#q_status_gteq').set('Disable')
  #     click_on 'Search'
  #     expect(page).to have_content(non_filtered_candidate.name)
  #     expect(page).to have_content(other_non_filtered_candidate.name)
  #   end
  # end

  it 'shows the training session' do
    within '#content' do
      expect(page).to have_content(sprint_radio_shack_training_session.name)
    end
  end

end