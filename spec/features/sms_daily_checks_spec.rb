require 'rails_helper'

describe 'SMS Daily Checks' do

  let!(:person) { create :person }
  let!(:sms) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_index] }
  let(:permission_group) { PermissionGroup.create name: 'SalesMakers Support' }
  #let(:permission_create) { Permission.create key: 'candidate_create', description: 'Blah blah blah', permission_group: permission_group }
  let(:permission_index) { Permission.create key: 'sms_daily_check_index', description: 'Blah blah blah', permission_group: permission_group }

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

    it 'has a title' do #BULLSHIT TEST
      expect(page).to have_content 'SalesMakers Support Dashboard'
    end

  end

end