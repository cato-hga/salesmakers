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

    describe 'Recruiting' do
      let(:recruiter) { create :person, position: position, email: 'recruiter@salesmakersinc.com' }
      let(:permissions) { create :permission }
      let(:position) { create :position, name: 'Advocate', department: department }
      let(:department) { create :department, name: 'Advocate Department' }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
        get :incoming_redirect
      end
      it 'returns a redirect status' do
        expect(response).to be_redirect
      end
      it 'routes Recruiters to candidates#index' do
        expect(response).to redirect_to(candidates_path)
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

    describe 'Human Resources' do
      let!(:human_resources_employee) { create :person, position: human_resources_position, email: 'human_resourcesemployee@salesmakersinc.com' }
      let(:human_resources_position) { create :position, name: 'Human Resources Position', department: human_resources_department }
      let(:human_resources_department) { create :department, name: 'Human Resources' }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(human_resources_employee.email)
        get :incoming_redirect
      end
      it 'returns a redirect' do
        expect(response).to be_redirect
      end
      it 'routes to the Devices root' do
        expect(response).to redirect_to(devices_path)
      end
    end

    describe 'Payroll' do
      let!(:payroll_employee) { create :person, position: payroll_position, email: 'payrollemployee@salesmakersinc.com' }
      let(:payroll_position) { create :position, name: 'Payroll Position', department: payroll_department }
      let(:payroll_department) { create :department, name: 'Payroll' }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(payroll_employee.email)
        get :incoming_redirect
      end
      it 'returns a redirect' do
        expect(response).to be_redirect
      end
      it 'routes to the Devices root' do
        expect(response).to redirect_to(devices_path)
      end
    end

    describe 'Vonage Sales' do
      let!(:vonage_employee) { create :person, position: vonage_position, email: 'vonagerep@vg.salesmakersinc.com' }
      let(:vonage_position) { create :position, name: 'Vonage Position', department: vonage_retail_department }
      let(:vonage_retail_department) { create :department, name: 'Vonage Retail Sales' }
      let(:vonage_events_department) { create :department, name: 'Vonage Retail Sales' }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(vonage_employee.email)

      end
      it 'returns a redirect for retail employees' do
        get :incoming_redirect
        expect(response).to be_redirect
      end
      it 'routes to commissions for retail employees' do
        get :incoming_redirect
        expect(response).to redirect_to(new_vonage_sale_path)
      end
      it 'returns a redirect for event employees' do
        vonage_position.update department: vonage_events_department
        get :incoming_redirect
        expect(response).to be_redirect
      end
      it 'routes to commissions for event employees' do
        vonage_position.update department: vonage_events_department
        get :incoming_redirect
        expect(response).to redirect_to(new_vonage_sale_path)
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