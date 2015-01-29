require 'rails_helper'

describe RootRedirectsController do

  describe 'GET incoming_redirect' do

    describe 'IT Department' do
      let!(:it_employee) { create :person, position: position, email: 'ittech@salesmakersinc.com' }
      let(:permissions) { create :permission }
      let(:position) { create :position, name: 'IT Tech', department: department }
      let(:department) { create :department, name: 'Information Technology' }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(it_employee.email)
        get :incoming_redirect
      end
      it 'returns a redirect status' do
        expect(response).to be_redirect
      end
      it 'routes IT to device#index' do
        expect(response).to redirect_to(devices_path)
      end
    end

    describe 'Executives' do
      let!(:executive) { create :person, position: position, email: 'executive@salesmakersinc.com' }
      let(:position) { create :position, name: 'Executives', department: department }
      let(:department) { create :department, name: 'Executives' }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(executive.email)
        get :incoming_redirect
      end
      it 'returns a redirect status' do
        expect(response).to be_redirect
      end
      it 'routes Executives to the people index' do
        expect(response).to redirect_to(people_path)
      end
    end


    describe 'Comcast Sales' do
      let!(:comcast_employee) { create :person, position: comcast_position, email: 'comcastemployee@cc.salesmakersinc.com' }
      let(:comcast_position) { create :position, name: 'Comcast Sales Specialist', department: comcast_department }
      let(:comcast_department) { create :department, name: 'Comcast Retail Sales' }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(comcast_employee.email)
        get :incoming_redirect
      end
      it 'returns a redirect' do
        expect(response).to be_redirect
      end
      it 'routes to the Comcast sales root' do
        expect(response).to redirect_to(new_comcast_customer_path)
      end
    end

    describe 'not yet implemented department' do
      let(:person) { create :person, position: unknown_position }
      let(:unknown_position) { create :position, department: unknown_department, name: 'Unknown' }
      let(:unknown_department) { create :department, name: 'Unknown' }

      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        get :incoming_redirect
      end

      it 'returns a success status' do
        expect(response).to be_success
      end

      it 'renders the coming soon template' do
        expect(response).to render_template(:incoming_redirect)
      end
    end
  end

end