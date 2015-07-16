require 'rails_helper'

describe 'roster verification' do
  let!(:vonage_paycheck) { create :vonage_paycheck, cutoff: Date.tomorrow.to_datetime }

  let(:employee) { create :person }
  let(:location) { create :location }
  let!(:shift) { create :shift, person: employee, date: Date.yesterday, location: location }

  let!(:root_area) { create :area, name: 'Root Area' }
  let!(:intermediate_area) { create :area, name: 'Intermediate Area' }
  let!(:bottom_area) { create :area, name: 'Bottom Area' }

  let!(:employee_person_area) { create :person_area, area: bottom_area, person: employee }

  let(:manager) { create :person }
  let!(:manager_person_area) { create :person_area, area: root_area, person: manager, manages: true }

  before do
    intermediate_area.update parent: root_area
    bottom_area.update parent: intermediate_area
    CASClient::Frameworks::Rails::Filter.fake(manager.email)
    visit new_roster_verification_session_path
  end

  it 'has the proper page title' do
    expect(page).to have_selector 'h1', text: 'Roster Verification'
  end

  it 'has a widget for each area' do
    expect(page).to have_selector '.widget h3', text: bottom_area.name
  end

  it 'lists employees in the area' do
    expect(page).to have_content employee.display_name
  end

  it "lists the employee's last shift date" do
    expect(page).to have_content '1 day ago'
  end

  it "lists the employee's last shift location" do
    expect(page).to have_content location.name
  end

  describe 'submission' do
    before { find('input[type="radio"]:first-child').click }

    subject { click_on 'Save' }

    it 'adds a RosterVerificationSession' do
      expect {
        subject
      }.to change(RosterVerificationSession, :count).by 1
    end

    it 'adds a RosterVerification' do
      expect {
        subject
      }.to change(RosterVerification, :count).by 1
    end
  end
end