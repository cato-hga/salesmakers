require 'rails_helper'

describe DevicesController do

  describe 'GET index' do
    before { get :index }

    it 'should return a success status' do
      expect(response).to be_success
    end

    it 'should render the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET new' do
    before { get :new }

    it 'should return a success status' do
      expect(response).to be_success
    end

    it 'should render the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
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
      let(:device_identifier) { '98765431' }
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

    context 'multiple devices success' do
      it 'assigns the correct line to the correct device'
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

  describe 'states' do
    let(:device) { create :device }
    let(:locked_state) { create :device_state, locked: true }
    let(:unlocked_state) { create :device_state, locked: false }

    describe 'PATCH remove_state' do
      context 'with an unlocked state' do
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

    describe 'PATCH lost_stolen' do
      subject {
        patch :lost_stolen,
              id: device.id
        device.reload
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
    end

    describe 'PATCH found' do
      before { device.device_states << lost_stolen }

      subject {
        patch :found,
              id: device.id
        device.reload
      }

      it 'removes the Lost or Stolen device state' do
        expect { subject }.to change(device.device_states, :count).by(-1)
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
    end

  end

  describe 'GET csv' do
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

  describe 'POST edit' do
    let(:device) { create :device }
    before(:each) do
      patch :edit,
            id: device.id,
            serial: '123456'
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    # it 'renders the show template' do
    #   expect(response).to render_template(:show)
    # end
    #
    # it 'updates the device with new information' do
    #   device.reload
    #   expect(device.serial).to eq('123456')
    # end
  end
end