require 'rails_helper'

describe RootRedirectsController do

  describe 'GET incoming_redirect' do

    describe 'IT Department' do
      let!(:it_employee) { create :person, position: position, email: 'ittech@salesmakersinc.com' }
      let(:permissions) { create :permission }
      let(:position) { create :position, name: 'IT Tech', department: department }
      let(:department) { create :department, name: 'Information Technology' }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
        get :incoming_redirect
      end
      after(:each) do
        CASClient::Frameworks::Rails::Filter.fake("retailingw@retaildoneright.com")
      end
      it 'returns a redirect status' do
        expect(response).to be_redirect
      end
      it 'routes IT to device#index' do
        expect(response).to redirect_to(devices_path)
      end
    end


    describe 'Comcast Sales' do
      let!(:comcast_employee) { create :person, position: comcast_position, email: 'comcastemployee@cc.salesmakersinc.com' }
      let(:comcast_position) { create :position, name: 'Comcast Sales Specialist', department: comcast_department }
      let(:comcast_department) { create :department, name: 'Comcast Retail Sales' }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake("comcastemployee@cc.salesmakersinc.com")
        get :incoming_redirect
      end
      after(:each) do
        CASClient::Frameworks::Rails::Filter.fake("retailingw@retaildoneright.com")
      end
      it 'returns a redirect' do
        expect(response).to be_redirect
      end
      it 'routes to the Comcast sales root' do
        expect(response).to redirect_to(new_comcast_customer_path)
      end
    end
  end
end