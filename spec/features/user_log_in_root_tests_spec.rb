require 'rails_helper'

describe 'User root log ins' do

#   #So, while the root redirects controller spec stubs out the controller itself, these tests are to test the root path
#   #being what it should be, and redirecting properly.
  describe 'IT Department' do
      let!(:it_employee) { create :person, position: position, email: 'ittech@salesmakersinc.com' }
      let(:permissions) { create :permission, key: 'device_index' }
      let(:position) { create :position, name: 'IT Tech', department: department }
      let(:department) { create :department, name: 'Information Technology' }
      before(:each) do
        position.permissions << permissions
        CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
        visit root_path
      end
      it 'routes IT to device#index' do
        expect(page).to have_content('Devices')
      end
  end
  describe 'Comcast Sales' do
    let!(:comcast_employee) { create :person, position: comcast_position, email: 'comcastemployee@cc.salesmakersinc.com' }
    let(:comcast_permissions) { create :permission, key: 'comcast_customer_create' }
    let(:comcast_position) { create :position, name: 'Comcast Sales Specialist', department: comcast_department }
    let(:comcast_department) { create :department, name: 'Comcast Retail Sales' }
    before(:each) do
      comcast_position.permissions << comcast_permissions
      CASClient::Frameworks::Rails::Filter.fake("comcastemployee@cc.salesmakersinc.com")
      visit root_path
    end
    it 'routes Comcast to comcast_sales#new' do
      expect(page).to have_content('New Comcast Customer')
    end
  end
end
