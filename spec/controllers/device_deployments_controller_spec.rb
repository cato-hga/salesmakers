require 'rails_helper'

describe DeviceDeploymentsController do

  let(:person) { create :person }
  let(:device) { create :device }

  describe 'GET select_user' do
    it 'returns a success status' do
      get :select_user, { device_id: device}
      expect(response).to be_success
    end
  end

  describe 'GET new' do
    it 'should render the new template' do
      get :new,
          person_id: person.id,
          device_id: device.id
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    context 'success' do
      before(:each) do
        post :create,
             device_id: device.id,
             person_id: person.id,
             device_deployment: {
                 device_id: device.id,
                 person_id: person.id,
                 tracking_number: '1111',
                 comment: 'Comment'
             }
        @deployment = DeviceDeployment.first
      end

      it 'should create a device_deployment' do
        expect(DeviceDeployment.count).to eq(1)
      end
      it 'should set the deployment start date to today' do
        expect(@deployment.started).to eq(Date.today)
      end
      it 'should set the tracking number provided' do
        expect(@deployment.tracking_number).to eq('1111')
      end
      it 'should add the comment provided' do
        expect(@deployment.comment).to eq('Comment')
      end
      it 'should assign the device to a given person' do
        device.reload
        expect(device.person).to eq(person)
      end
      it 'should flash a success message' do
        expect(flash[:notice]).to eq('Device Deployed!')
      end
      it 'should redirect to the device' do
        expect(response).to redirect_to(device)
      end
    end

    context 'failure' do
      before {
        post :create,
             device_id: device.id,
             person_id: person.id,
             device_deployment: {
                 device_id: nil,
                 person_id: nil
             }
      }
      it 'should render the new template' do
        expect(response).to redirect_to 'new'
      end
      it 'should flash an error message' do
        expect(flash[:error]).to eq('Could not deploy Device!')
      end
    end
  end

  describe 'GET recoup' do
    let(:deployed_device) { create :device }
    let(:person) { create :person }
    let(:deployed) { DeviceState.find_by name: 'Deployed' }
    let(:device_deployment) { create :device_deployment, device: deployed_device, person: person }
    context 'success' do
      before(:each) do
        deployed_device.device_states << deployed
        deployed_device.device_deployments << device_deployment
        deployed_device.person = person
        get :recoup, device_id: deployed_device.id
      end
      it 'redirects to the device' do
        expect(response).to redirect_to deployed_device
      end

      it 'removes the device from the person' do
        deployed_device.reload
        expect(deployed_device.person_id).not_to eq(person.id)
      end

      it 'should flash a confirmation message' do
        expect(flash[:notice]).to eq('Device Recouped!')
      end
    end
  end
end
