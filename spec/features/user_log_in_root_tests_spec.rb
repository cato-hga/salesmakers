require 'rails_helper'

describe 'User root log ins' do

#   #So, while the root redirects controller spec stubs out the controller itself, these tests are to test the root path
#   #being what it should be, and redirecting properly.
  describe 'IT Department' do
    describe 'IT Department' do
      let!(:it_employee) { create :person, position: position, email: 'ittech@salesmakersinc.com' }
      let(:permissions) { Permission.find_by key: 'device_index' }
      let(:position) { create :position, name: 'IT Tech', department: department }
      let(:department) { Department.find_by name: 'Information Technology' }
      before(:each) do
        position.permissions << permissions
        CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
        visit root_path
      end
      after(:each) do
        CASClient::Frameworks::Rails::Filter.fake("retailingw@retaildoneright.com")
      end
      it 'routes IT to device#index' do
        expect(page).to have_content('Devices')
      end
    end
  end
end