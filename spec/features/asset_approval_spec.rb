require 'rails_helper'

describe 'Approving or Denying assets' do

  let(:manager) { create :person, display_name: 'Manager' }
  let(:sprint_manager) { create :person, display_name: 'Sprint Manager' }

  let(:employee_one) { create :person, display_name: 'Employee One', passed_asset_hours_requirement: true }
  let(:employee_two) { create :person, display_name: 'Employee Two', passed_asset_hours_requirement: false }
  let(:employee_three) { create :person, display_name: 'Employee Three', passed_asset_hours_requirement: true }
  let(:employee_four) { create :person, display_name: 'Employee four', passed_asset_hours_requirement: true }
  let!(:device) { create :device, person: employee_three }

  let!(:employee_one_area) { create :person_area, person: employee_one, area: area }
  let!(:employee_two_area) { create :person_area, person: employee_two, area: area }
  let!(:employee_three_area) { create :person_area, person: employee_three, area: area }
  let!(:employee_four_area) { create :person_area, person: employee_four, area: sprint_area }
  let!(:sprint_manager_area) { create :person_area, person: sprint_manager, area: sprint_area, manages: true }
  let!(:manager_area) { create :person_area, person: manager, area: area, manages: true }
  let(:area) { create :area, project: vonage }
  let(:vonage) { create :project, name: 'Vonage' }
  let(:sprint_area) { create :area, project: sprint }
  let(:sprint) { create :project, name: 'Sprint Retail' }
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
    describe 'selecting' do
      context 'vonage employees' do
        it 'shows employee without assets' do
          CASClient::Frameworks::Rails::Filter.fake(manager.email)
          visit asset_approval_path
          expect(page).to have_content employee_one.display_name
          expect(page).not_to have_content employee_two.display_name
          expect(page).not_to have_content employee_three.display_name
          expect(page).not_to have_content employee_four.display_name
        end
        context ' for approval' do
          before {
            CASClient::Frameworks::Rails::Filter.fake(manager.email)
            visit asset_approval_path
            click_on 'Approve'
            employee_one.reload
          }
          it 'sets the vonage table status to approved' do
            expect(employee_one.vonage_tablet_approval_status).to eq('approved')
          end
          it 'renders the approval template again' do
            expect(current_path).to eq(asset_approval_path)
          end
          it 'removes the employee off the approval list' do
            expect(page).not_to have_content(employee_one.display_name)
          end
        end
        context 'denial' do
          before {
            CASClient::Frameworks::Rails::Filter.fake(manager.email)
            visit asset_approval_path
            click_on 'Deny'
            employee_one.reload
          }
          it 'sets the vonage table status to approved' do
            expect(employee_one.vonage_tablet_approval_status).to eq('denied')
          end
          it 'renders the approval template again' do
            expect(current_path).to eq(asset_approval_path)
          end
          it 'removes the employee off the approval list' do
            expect(page).not_to have_content(employee_one.display_name)
          end
        end

        context 'sprint employees' do
          it 'shows employee without assets' do
            CASClient::Frameworks::Rails::Filter.fake(sprint_manager.email)
            visit asset_approval_path
            expect(page).not_to have_content employee_one.display_name
            expect(page).not_to have_content employee_two.display_name
            expect(page).not_to have_content employee_three.display_name
            expect(page).to have_content employee_four.display_name
          end
          context 'for approval' do
            before {
              CASClient::Frameworks::Rails::Filter.fake(sprint_manager.email)
              visit asset_approval_path
              click_on 'Approve'
              employee_four.reload
            }
            it 'sets the print prepaid asset status to approved' do
              expect(employee_four.sprint_prepaid_asset_approval_status).to eq('prepaid_approved')
            end
            it 'renders the approval template again' do
              expect(current_path).to eq(asset_approval_path)
            end
            it 'removes the employee off the approval list' do
              expect(page).not_to have_content(employee_four.display_name)
            end
          end
          context 'denial' do
            before {
              CASClient::Frameworks::Rails::Filter.fake(sprint_manager.email)
              visit asset_approval_path
              click_on 'Deny'
              employee_four.reload
            }
            it 'sets the vonage table status to approved' do
              expect(employee_four.sprint_prepaid_asset_approval_status).to eq('prepaid_denied')
            end
            it 'renders the approval template again' do
              expect(current_path).to eq(asset_approval_path)
            end
            it 'removes the employee off the approval list' do
              expect(page).not_to have_content(employee_four.display_name)
            end
          end
        end
      end
    end
  end
end