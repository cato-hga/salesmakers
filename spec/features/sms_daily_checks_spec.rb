require 'rails_helper'

describe 'SMS Daily Checks' do

  let(:person_one) { create :person }
  let(:person_two) { create :person }

  let(:first_person_area) { create :person_area, person: person_one, area: area_one }
  let(:second_person_area) { create :person_area, person: person_two, area: area_two }

  let!(:sms) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_index] }
  let(:permission_group) { PermissionGroup.create name: 'SalesMakers Support' }
  #let(:permission_create) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_index) { Permission.create key: 'sms_daily_check_index', description: 'Blah blah blah', permission_group: permission_group }

  let(:area_one) { create Area, name: 'First Area' }
  let(:area_two) { create Area, name: 'Second Area' }


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

    it 'allows for selecting different teams' do
      select 'First Area', from: :team_select
      click_on 'View'
      expect(page).to have_content person_one.name
      select 'Second Area', from: :team_select
      click_on 'View'
      expect(page).to have_content person_two.name
    end

  end

end