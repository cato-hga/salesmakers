require 'rails_helper'

describe DevicesController do
  include ActiveJob::TestHelper

  describe 'GET index' do
    before {
      allow(controller).to receive(:policy).and_return double(index?: true)
      get :index }

    it 'should return a success status' do
      expect(response).to be_success
    end

    it 'should render the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET new' do
    before {
      allow(controller).to receive(:policy).and_return double(new?: true)
      get :new
    }

    it 'should return a success status' do
      expect(response).to be_success
    end

    it 'should render the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      allow(controller).to receive(:policy).and_return double(create?: true)
    end
    context 'success (valid data)' do
      subject {
        post :create,
             contract_end_date: contract_end_date.strftime('%m/%d/%Y'),
             device_model_id: device_model.id,
             technology_service_provider_id: service_provider.id,
             serial: [serial],
             line_identifier: [line_identifier]
      }
      let!(:device_model) { create :device_model }
      let!(:service_provider) { create :technology_service_provider }
      let(:line_identifier) { '5555555555' }
      let(:serial) { '123456789' }
      let(:contract_end_date) { Date.today + 1.year }

      it 'creates a device' do
        expect { subject }.to change(Device, :count).by(1)
      end

      it 'creates a line' do
        expect { subject }.to change(Line, :count).by(1)
      end

      it 'creates log entries' do
        expect { subject }.to change(LogEntry, :count).by(2)
      end

      it 'should redirect to devices#index' do
        expect(subject).to redirect_to(devices_path)
      end

      it 'assigns the correct line to the correct asset' do
        subject
        device = Device.first
        line = Line.first
        expect(device.line).to eq(line)
      end
    end

    context 'devices with secondary identifiers' do

      let!(:device_model) { create :device_model }
      let!(:service_provider) { create :technology_service_provider }
      let(:line_identifier) { '5555555555' }
      let(:serial) { '1234567890' }
      let(:device_identifier) { '98765431' }
      let(:contract_end_date) { Date.today + 1.year }
      subject {
        post :create,
             contract_end_date: contract_end_date.strftime('%m/%d/%Y'),
             device_model_id: device_model.id,
             technology_service_provider_id: service_provider.id,
             serial: [serial],
             line_identifier: [line_identifier],
             device_identifier: [device_identifier]
      }

      it 'creates a device' do
        expect { subject }.to change(Device, :count).by(1)
      end

      it 'creates a line' do
        expect { subject }.to change(Line, :count).by(1)
      end

      it 'assigns the correct line to the correct asset' do
        subject
        device = Device.first
        line = Line.first
        expect(device.line).to eq(line)
      end

      it 'assigns the correct secondary identifier to the correct asset' do
        subject
        device = Device.first
        expect(device.identifier).to eq(device_identifier)
      end
    end

    context 'failure' do
      let!(:device_model) { create :device_model }
      let!(:service_provider) { create :technology_service_provider }
      let(:invalid_line_identifier) { '55505555555' }
      let(:serial) { '123456789' }
      let(:device_identifier) { '98765431' }
      let(:contract_end_date) { Date.today + 1.year }

      context 'invalid data' do
        subject {
          post :create,
               contract_end_date: contract_end_date.strftime('%m/%d/%Y'),
               device_model_id: device_model.id,
               technology_service_provider_id: service_provider.id,
               serial: [serial],
               line_identifier: [invalid_line_identifier]
        }

        it 'should render the new template' do
          expect(subject).to render_template(:new)
        end
      end
    end
  end


  describe 'GET show' do
    let(:device) { create :device }
    before {
      allow(controller).to receive(:policy).and_return double(show?: true)
      get :show,
          id: device.id
    }
    it 'should return a success status' do
      expect(response).to be_success
    end

    it 'should render the show template' do
      expect(response).to render_template(:show)
    end
  end

  describe 'GET write_off' do
    let(:device) { create :device }
    let!(:written_off) { create :device_state, name: 'Written Off' }
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      allow(controller).to receive(:policy).and_return double(write_off?: true)
    end
    subject { get :write_off, id: device.id }

    it 'should render the show template' do
      expect(subject.request).to redirect_to(device)
    end

    it 'should assign the "Written Off" device status' do
      subject
      expect(device.device_states).to include(written_off)
    end

    it 'should flash a confirmation message' do
      expect(subject.request.flash[:notice]).to eq('Device Written Off!')
    end

    it 'should create a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end
  end

  describe 'GET line_edit' do
    let(:it_tech) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
      allow(controller).to receive(:policy).and_return double(line_edit?: true)
      get :line_edit
    end
    it 'should return a success status.' do
      expect(response).to be_success
    end

    it 'renders the line edit template' do
      expect(response).to render_template("line_edit")
    end
  end

  describe 'states' do
    let(:device) { create :device }
    let(:locked_state) { create :device_state, locked: true }
    let(:unlocked_state) { create :device_state, locked: false }
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
    end
    describe 'PATCH remove_state' do
      context 'with an unlocked state' do
        before(:each) do
          allow(controller).to receive(:policy).and_return double(remove_state?: true)
        end
        subject {
          patch :remove_state,
                id: device.id,
                device_state_id: unlocked_state.id
        }

        it 'removes the device state' do
          device.device_states << unlocked_state
          expect { subject }.to change(device.device_states, :count).by(-1)
        end

        it 'logs the removal of the device state' do
          expect { subject }.to change(LogEntry, :count).by(1)
        end
      end

      context 'with a locked state' do
        it 'allows the removal of the device state' do
          device.device_states << locked_state
          expect {
            patch :remove_state,
                  id: device.id,
                  device_state_id: locked_state.id
          }.not_to change(device.device_states, :count)
        end
      end
    end

    describe 'PATCH add_state' do
      context 'with an unlocked state' do
        before(:each) do
          allow(controller).to receive(:policy).and_return double(add_state?: true)
        end
        subject {
          patch :add_state,
                id: device.id,
                device_state_id: unlocked_state.id
        }

        it 'allows an unlocked state to be added' do
          expect { subject }.to change(device.device_states, :count).by(1)
        end

        it 'logs the removal of the device state' do
          expect { subject }.to change(LogEntry, :count).by(1)
        end
      end

      it 'does not allow a locked state to be added' do
        expect {
          patch :add_state,
                id: device.id,
                device_state_id: locked_state.id
        }.not_to change(device.device_states, :count)
      end
    end
  end

  context 'lost or stolen' do
    let(:device) { create :device }
    let!(:lost_stolen) { create :device_state, name: 'Lost or Stolen', locked: true }
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
    end

    describe 'PATCH lost_stolen' do
      before(:each) do
        allow(controller).to receive(:policy).and_return double(lost_stolen?: true)
      end
      subject {
        patch :lost_stolen,
              id: device.id
      }

      it 'does not add the Lost/Stolen state if already lost or stolen' do
        device.device_states << lost_stolen
        device.reload
        expect { subject }.not_to change(device.device_states, :count)
      end

      it 'adds the Lost/Stolen state to devices that do not have it' do
        expect { subject }.to change(device.device_states, :count).by(1)
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end

      it 'DOES NOT email payroll if not deployed' do
        expect {
          subject
        }.to change(enqueued_jobs, :count).by(0)
      end

      context 'if deployed' do
        let!(:deployed_person) { create :person }
        it 'emails Payroll Assets' do
          device.update person: deployed_person
          device.reload
          expect {
            subject
            perform_enqueued_jobs do
              ActionMailer::DeliveryJob.new.perform(*enqueued_jobs.first[:args])
            end
          }.to change(ActionMailer::Base.deliveries, :count).by(1)
        end
      end
    end
  end

  describe 'PATCH found' do
    let(:device) { create :device }
    let!(:lost_stolen) { create :device_state, name: 'Lost or Stolen', locked: true }
    let!(:written_off) { create :device_state, name: 'Written Off', locked: true }
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
    end
    before(:each) do
      allow(controller).to receive(:policy).and_return double(found?: true)
    end

    subject {
      patch :found,
            id: device.id
      device.reload
    }

    it 'removes the Lost or Stolen device' do
      device.device_states = [lost_stolen]
      subject
      expect(device.device_states).not_to include(lost_stolen)
    end

    it 'removes the Written off device state' do
      device.device_states = [written_off]
      subject
      expect(device.device_states).not_to include(written_off)
    end

    it 'removes multiple states, if found' do
      device.device_states = [written_off, lost_stolen]
      subject
      expect(device.device_states).to eq([])
    end

    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end

    it 'DOES NOT email payroll if not deployed' do
      expect {
        subject
      }.to change(enqueued_jobs, :count).by(0)
    end

    context 'if deployed' do
      let!(:deployed_person) { create :person }
      it 'emails Payroll Assets' do
        device.update person: deployed_person
        expect {
          subject
          perform_enqueued_jobs do
            ActionMailer::DeliveryJob.new.perform(*enqueued_jobs.first[:args])
          end
        }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end

  describe 'GET csv' do
    before(:each) do
      allow(controller).to receive(:policy).and_return double(csv?: true)
    end
    it 'returns a success status for CSV format' do
      get :csv,
          format: :csv
      expect(response).to be_success
    end

    it 'redirects an HTML format' do
      get :csv
      expect(response).to redirect_to(devices_path)
    end
  end

  describe 'GET edit' do
    let(:device) { create :device }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(edit?: true)
      get :edit,
          id: device.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the edit template' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH update' do
    let(:device) { create :device }
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      allow(controller).to receive(:policy).and_return double(update?: true)
    end
    subject do
      patch :update,
            id: device.id,
            serial: '123456',
            device_identifier: 'B56691513608935569',
            device_model_id: device.device_model_id

    end

    it 'renders the show template' do
      subject
      expect(response).to redirect_to(device)
    end

    it 'updates the device with new information' do
      subject
      device.reload
      expect(device.serial).to eq('123456')
      expect(device.identifier).to eq('B56691513608935569')
    end

    it 'creates log entries' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end
  end

  describe 'PATCH repair' do
    let(:device) { create :device }
    let!(:repair) { create :device_state, name: 'Repairing', locked: true }
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      allow(controller).to receive(:policy).and_return double(repairing?: true)
    end
    subject {
      patch :repairing,
            id: device.id
      device.reload
    }

    it 'does not add the Repair state if already in repair' do
      device.device_states << repair
      device.reload
      expect { subject }.not_to change(device.device_states, :count)
    end

    it 'adds the Repair state to devices that do not have it' do
      expect { subject }.to change(device.device_states, :count).by(1)
    end

    it 'creates a log entry' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end

  end

  describe 'PATCH repaired' do
    let!(:device) { create :device, device_states: [repair] }
    let(:repair) { create :device_state, name: 'Repairing', locked: true }
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(repaired?: true)
      CASClient::Frameworks::Rails::Filter.fake(person.email)
    end
    subject {
      patch :repaired,
            id: device.id
    }

    it 'removes the Repair state from devices that do have it' do
      expect {
        subject
        device.reload
      }.to change(device.device_states, :count).by(-1)
      expect(device.device_states).not_to include(repair)
    end

    it 'creates a log entry' do
      expect {
        subject
        device.reload
      }.to change(LogEntry, :count).by(1)
    end

    it 'redirects to the device page' do
      subject
      expect(response).to redirect_to(device)
    end
  end

  describe 'GET line_swap_or_move' do
    let(:device) { create :device }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(line_swap_or_move?: true)
      get :line_swap_or_move,
          id: device.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'should render the swap or move template' do
      expect(response).to render_template(:line_swap_or_move)
    end
  end

  describe 'GET line_move_results' do
    let(:device_one) { create :device, line: device_one_line }
    let(:device_one_line) { create :line }
    let(:device_two) { create :device }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(line_move_results?: true)
      get :line_move_results,
          id: device_one.id,
          device_id: device_two.id
    end
    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'should render the line move results template' do
      expect(response).to render_template(:line_move_results)
    end
  end

  describe 'PATCH line_move_finalize' do
    let!(:device_one) { create :device, line: line }
    let!(:line) { create :line }
    let(:device_two) { create :device }
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(line_move_finalize?: true)
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      patch :line_move_finalize,
            id: device_one.id,
            device_id: device_two.id
      device_one.reload
      device_two.reload
    end

    it 'moves the line to the new device' do
      expect(device_one.line).to be_nil
      expect(device_two.line).to eq(line)
    end
    it 'renders show template for the original device' do
      expect(response).to redirect_to device_one
    end
    it 'creates log entries on both devices' do
      expect(LogEntry.all.count).to eq(2)
    end
  end

  describe 'GET line_swap_results' do
    let(:device_one) { create :device, line: line_one }
    let(:line_one) { create :line }
    let(:device_two) { create :device, line: line_two }
    let(:line_two) { create :line }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(line_swap_results?: true)
      get :line_swap_results,
          id: device_one.id,
          device_id: device_two.id
    end
    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'should render the swap results template' do
      expect(response).to render_template(:line_swap_results)
    end
  end

  describe 'PATCH line_swap_finalize' do
    let!(:device_one) { create :device, line: line_one }
    let!(:line_one) { create :line, identifier: '9876543210' }
    let!(:line_two) { create :line }
    let!(:device_two) { create :device, line: line_two, serial: '123852', identifier: '123852' }
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(line_swap_finalize?: true)
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      patch :line_swap_finalize,
            id: device_one.id,
            device_id: device_two.id
      device_one.reload
      line_one.reload
      device_two.reload
      line_two.reload
    end

    it 'swaps the devices line to the provided new line' do
      expect(device_one.line).to eq(line_two)
      expect(device_two.line).to eq(line_one)
    end
    it 'renders show template for the first device' do
      expect(response).to redirect_to device_one
    end
    it 'creates log entries' do
      expect(LogEntry.all.count).to eq(2)
    end
  end
end
