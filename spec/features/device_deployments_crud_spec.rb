require 'rails_helper'

describe 'Device Deployments CRUD actions' do

  describe 'GET select_user' do
    let(:device) { create :device }
    before do
      visit device_path device
      click_link 'Deploy'
    end
    it 'should give a list of users' do
      expect(page).to have_content('System Administrator')
    end

    it 'should redirect to the "new" action when a Deploy button is clicked' do
      click_link 'Deploy'
      expect(page).to have_content("New Deployment Information")
    end
  end

  describe 'GET new' do
    let(:device) { create :device, person_id: person.id}
    let(:person) { Person.first }
    before do
      visit device_path device
      click_link 'Deploy'
      click_link 'Deploy'
    end
    it 'should prompt for tracking and comments' do
      expect(page).to have_content 'Tracking number'
      expect(page).to have_content 'Comment'
    end
    it 'should show a list of current devices assigned to a user' do
      expect(page).to have_content 'Current Devices Assigned'
    end
  end

  describe 'GET recoup' do
    let(:device) { create :device }
    before(:each) do
      visit device_path device
      click_link 'Recoup'
    end

    it 'should prompt for confirmation', js: true do
      expect(page).to have_content('Are you sure?')
    end


    it 'should NOT show the deployed status'
    it 'should create a log entry'
    it 'should show a recouped record in the device history'
  end
end
