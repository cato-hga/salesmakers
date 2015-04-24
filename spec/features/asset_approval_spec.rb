require 'rails_helper'

describe 'Approving or Denying assets' do

  let!(:manager) { create :person, display_name: 'Manager' }

  let(:employee_one) { create :person, display_name: 'Employee One', passed_asset_hours_requirement: true }
  let(:employee_two) { create :person, display_name: 'Employee Two', passed_asset_hours_requirement: false }
  let(:employee_three) { create :person, display_name: 'Employee Three', passed_asset_hours_requirement: true }
  let!(:device) { create :device, person: employee_three }

  let!(:employee_one_area) { create :person_area, person: employee_one, area: area }
  let!(:employee_two_area) { create :person_area, person: employee_two, area: area }
  let!(:employee_three_area) { create :person_area, person: employee_three, area: area }
  let!(:manager_area) { create :person_area, person: manager, area: area, manages: true }
  let(:area) { create :area }

  describe 'for unauthorized users' do
    let(:unauth_person) { create :person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit asset_approval_path
    end

    it "shows the 'You are not authorized' page" do
      expect(page).to have_content('Your access does not allow you to view this page')
    end
  end

  describe 'for authorized users' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(manager.email)
      visit asset_approval_path
    end

    it 'shows employee without assets' do
      expect(page).to have_content employee_one.display_name
      expect(page).not_to have_content employee_two.display_name
      expect(page).not_to have_content employee_three.display_name
    end

    describe 'selecting' do
      context 'approval' do
        before {
          click_on 'Approve'
        }
        it 'sets the vonage table status to approved' do

        end
        it 'renders the approval template again'
        it 'removes the employee off the approval list'
      end
      context 'denial' do
        it 'sets the vonage table status to denied'
        it 'renders the approval template again'
        it 'removes the employee off the approval list'
      end
    end
  end
end