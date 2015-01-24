require 'rails_helper'

describe 'Device Deployments CRUD actions' do
  let!(:it_tech) { create :it_tech_person }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
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
end
