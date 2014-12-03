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

end