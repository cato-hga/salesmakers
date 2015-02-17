require 'rails_helper'

describe DeviceDeploymentsController do
  include ActiveJob::TestHelper

  let(:device) { create :device }
  let!(:person) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position }
  before(:each) do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

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
      subject do
        post :create,
             device_id: device.id,
             person_id: person.id,
             device_deployment: {
                 device_id: device.id,
                 person_id: person.id,
                 tracking_number: '1111',
                 comment: 'Comment'
             }
      end

      let(:deployment) {
        subject
        DeviceDeployment.first
      }

      it 'creates a DeviceDeployment' do
        expect{ subject }.to change(DeviceDeployment, :count).by(1)
      end

      it 'should set the deployment start date to today' do
        expect(deployment.started).to eq(Date.today)
      end

      it 'should set the tracking number provided' do
        expect(deployment.tracking_number).to eq('1111')
      end

      it 'should add the comment provided' do
        expect(deployment.comment).to eq('Comment')
      end

      it 'should assign the device to a given person' do
        subject
        device.reload
        expect(device.person).to eq(person)
      end

      it 'should flash a success message' do
        subject
        expect(flash[:notice]).to eq('Device Deployed!')
      end

      it 'should redirect to the device' do
        subject
        expect(response).to redirect_to(device)
      end

      it 'creates a log entry for the deployment' do
        expect{ subject }.to change(LogEntry, :count).by(1)
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

  describe 'recouping' do
    let(:deployed_device) { create :device, serial: '123458',
                                   identifier: '123458',
                                   line: line,
                                   device_deployments: [device_deployment],
                                   device_states: [deployed] }
    let!(:recouped_person) { create :person, personal_email: 'test@test.com', devices: [deployed_device] }
    let(:line) { create :line }
    let(:deployed) { create :device_state, name: 'Deployed' }
    let(:device_deployment) { create :device_deployment, person: person }
    let(:notes) { 'Good condition - $0' }

    describe 'GET recoup_notes' do
      before do
        get :recoup_notes, device_id: deployed_device.id
      end

      it 'returns a success status' do
        expect(response).to be_success
      end

      it 'renders the recoup_notes template' do
        expect(response).to render_template(:recoup_notes)
      end
    end

    describe 'POST recoup' do
      context 'success' do
        subject do
          post :recoup, device_id: deployed_device.id, notes: notes
        end
        it 'redirects to the device' do
          expect(subject.request).to redirect_to deployed_device
        end

        it 'removes the device from the person' do
          expect(deployed_device.person).to eq(recouped_person)
          subject
          deployed_device.reload
          expect(deployed_device.person).not_to eq(recouped_person)
        end

        it 'should flash a confirmation message' do
          expect(subject.request.flash[:notice]).to eq('Device Recouped!')
        end

        it 'should create a log entry' do
          expect { subject }.to change(LogEntry, :count).by(1)
        end

        it 'should save the notes' do
          subject
          expect(LogEntry.first.comment).to eq(notes)
        end

        it 'should save the notes as comments' do
          subject
          device_deployment.reload
          expect(device_deployment.comment).to eq(notes)
        end

        it 'sends an email to payroll' do
          expect {
            subject
            perform_enqueued_jobs do
              ActionMailer::DeliveryJob.new.perform(*enqueued_jobs.first[:args])
            end
          }.to change(ActionMailer::Base.deliveries, :count).by(1)
        end
      end

      context 'success without notes' do
        subject do
          post :recoup, device_id: deployed_device.id
        end
        it 'handles no comment' do
          subject
          expect(device_deployment.comment).to eq(nil)
        end
      end
    end
  end
end
