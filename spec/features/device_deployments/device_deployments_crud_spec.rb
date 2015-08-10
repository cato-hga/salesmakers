require 'rails_helper'

describe 'Device Deployments CRUD actions' do
  let!(:person) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end
  describe 'GET new' do
    let(:device) { create :device, person_id: person.id}
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
end