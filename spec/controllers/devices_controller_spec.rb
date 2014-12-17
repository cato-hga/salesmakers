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
        it 'presents an error when form is invalid' do
          subject
          expect(flash[:error]).to be_present
        end
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
end