require 'rails_helper'

describe 'SMS Daily Checks' do

  let(:person_one) { create :person, display_name: 'Test User 1' }
  let(:person_two) { create :person, display_name: 'Test User 2' }
  let(:person_three) { create :person, display_name: 'Test User 3' }

  let!(:first_person_area) { create :person_area, person: person_one, area: area_one }
  let!(:second_person_area) { create :person_area, person: person_two, area: area_two }
  let!(:three_person_area) { create :person_area, person: person_three, area: area_three }

  let!(:sms) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_index] }
  let(:permission_group) { PermissionGroup.create name: 'SalesMakers Support' }
  #let(:permission_create) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_index) { Permission.create key: 'sms_daily_check_index', description: 'Blah blah blah', permission_group: permission_group }

  let(:project) { create :project, name: 'STAR' }
  let(:area_one) { create :area, name: 'First Area', project: project }
  let(:area_two) { create :area, name: 'Second Area', project: project }
  let(:area_three) { create :area, name: 'Third Area', project: project }


  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit sms_daily_checks_path
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(sms.email)
      visit sms_daily_checks_path
    end

    it 'contains the action buttons' do
      expect(page).to have_button 'Post Roll Call'
      expect(page).to have_button 'Post Check In'
      expect(page).to have_button 'Post Mid Day'
      expect(page).to have_button 'Post Check Out'
    end

    it 'allows for selecting different teams' do
      select 'First Area', from: :select_team
      click_on 'View'
      expect(page).to have_content person_one.name
      expect(page).not_to have_content person_three.name
      select 'Second Area', from: :select_team
      click_on 'View'
      expect(page).to have_content person_two.name
      expect(page).not_to have_content person_three.name
    end

    it 'allows for selecting multiple teams' do
      select 'First Area', from: :select_team
      select 'Second Area', from: :select_team
      click_on 'View'
      expect(page).to have_content person_one.name
      expect(page).to have_content person_two.name
      expect(page).not_to have_content person_three.name
    end

    it 'shows the check in info upon clicking an employees name' do
      select 'First Area', from: :select_team
      click_on 'View'
      click_on person_one.name
      expect(page).to have_content 'Check In'
      expect(page).to have_content 'Mid Day'
      expect(page).to have_content 'Check Out'
      expect(page).to have_content 'Notes'
      expect(page).to have_content 'Save/Employee Off'
    end

    context 'updating the daily check' do

      it 'saves the correct info', pending: true do
        select 'First Area', from: :select_team
        click_on 'View'
        select '7:00am', from: :in_time
        select '9:00am', from: :out_time
        check :roll_call
        check :check_in_on_time
        check :blueforce_geotag
        check :check_in_uniform
        check :check_in_inside_store
        check :accountability_check_in_1
        check :accountability_check_in_2
        check :accountability_check_in_3
        check :check_out_on_time
        check :check_out_inside_store
        fill_in :sales, with: 2
        fill_in :notes, with: "test notes"
        click_on 'Save'
        check = SMSDailyCheck.first
        expect(check.in_time).to eq('2015-06-22 07:00:00 -0400')
        expect(check.out_time).to eq('2015-06-22 09:00:00 -0400')
        expect(check.roll_call).to eq(true)
        expect(check.check_in_on_time).to eq(true)
        expect(check.blueforce_geotag).to eq(true)
        expect(check.check_in_uniform).to eq(true)
        expect(check.check_in_inside_store).to eq(true)
        expect(check.accountability_check_in_1).to eq(true)
        expect(check.accountability_check_in_2).to eq(true)
        expect(check.accountability_check_in_3).to eq(true)
        expect(check.check_out_on_time).to eq(true)
        expect(check.check_out_inside_store).to eq(true)
        expect(check.sales).to eq(2)
        expect(check.notes).to eq("test notes")
        expect(check.date).to eq(Date.today)
      end
      it 'allows for updating the saved information'

    end

    context 'marking the employee as off' do
      it 'saves the correct info'
      it 'shows the employee as being off on the index page'
    end

  end

end