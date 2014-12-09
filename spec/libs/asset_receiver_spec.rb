require 'rails_helper'

RSpec.describe 'Asset Receiver' do

  before {
    @attrs = {
        creator: creator,
        device_model: device_model,
        service_provider: service_provider,
        line_identifier: line_identifier,
        serial: serial,
        device_identifier: device_identifier,
        contract_end_date: Date.today + 1.year
    }
  }
  let(:device_model) { create :device_model }
  let(:service_provider) { create :technology_service_provider }
  let(:line_identifier) { '5555555555' }
  let(:serial) { '123456789' }
  let(:device_identifier) { '98765431' }
  let(:creator) { create :person }
  let(:receiver) { AssetReceiver.new @attrs }

  describe 'validations' do
    it 'pass with the correct inputs' do
      expect(receiver).to be_valid
    end
    it 'do not pass when service provider is present but line identifier is not' do
      invalid_receiver = AssetReceiver.new @attrs.merge(line_identifier: nil)
      expect(invalid_receiver).not_to be_valid_line_identifier
      expect(invalid_receiver).not_to be_valid
    end
    it 'do not pass when line identifier is present but service provider is not' do
      invalid_receiver = AssetReceiver.new @attrs.merge(service_provider: nil)
      expect(invalid_receiver).not_to be_valid_service_provider
      expect(invalid_receiver).not_to be_valid
    end
    it 'do not pass when a contract end date is present but line_identifier is not' do
      invalid_receiver = AssetReceiver.new @attrs.merge(line_identifier: nil)
      expect(invalid_receiver).not_to be_valid_line_identifier
      expect(invalid_receiver).not_to be_valid
    end
    it 'do not pass when a line identifier is present but a contract end date is not' do
      invalid_receiver = AssetReceiver.new @attrs.merge(contract_end_date: nil)
      expect(invalid_receiver).not_to be_valid_contract_end_date
      expect(invalid_receiver).not_to be_valid
    end
    it 'require a serial' do
      invalid_receiver = AssetReceiver.new @attrs.merge(serial: nil)
      expect(invalid_receiver).not_to be_valid_serial
      expect(invalid_receiver).not_to be_valid
    end
    it 'require a device model' do
      invalid_receiver = AssetReceiver.new @attrs.merge(device_model: nil)
      expect(invalid_receiver).not_to be_valid_device_model
      expect(invalid_receiver).not_to be_valid
    end
    it 'allow nil values for line and service provider and contract end date' do
      valid_receiver = AssetReceiver.new @attrs.merge(line_identifier: nil, service_provider: nil, contract_end_date: nil)
      expect(valid_receiver).to be_valid_service_provider
      expect(valid_receiver).to be_valid_contract_end_date
      expect(valid_receiver).to be_valid_line_identifier
      expect(valid_receiver).to be_valid
    end
    it 'require a creator (person)' do
      invalid_receiver = AssetReceiver.new @attrs.merge(creator: nil)
      expect(invalid_receiver).not_to be_valid_creator
      expect(invalid_receiver).not_to be_valid
    end
  end

  describe 'asset receiving' do
    it 'uses the devices serial as device_identifier if no identifier is provided' do
      receiver = AssetReceiver.new @attrs.merge(device_identifier: nil)
      expect(receiver.device_identifier).to eq(serial)
    end
    it 'sets the device identifier if provided' do
      expect(receiver.device_identifier).to eq(device_identifier)
    end
    it 'creates a device' do
      expect { receiver.receive }.to change(Device, :count).by(1)
    end
    it 'creates a line' do
      expect { receiver.receive }.to change(Line, :count).by(1)
    end
    it 'creates a log entry for receiving' do
      expect { receiver.receive }.to change(LogEntry, :count).by(2)
    end
  end

  describe 'attribute assignment' do
    before(:each) do
      receiver.receive
    end

    let(:device) { Device.first }
    let(:line) { Line.first }
    let(:log) { LogEntry.first }

    it 'sets the proper service provider' do
      expect(line.technology_service_provider).to eq(service_provider)
    end
    it 'sets the proper manufacturer and model' do
      expect(device.device_model).to eq(device_model)
    end
    it 'sets the proper device serial' do
      expect(device.serial).to eq(serial)
    end
    it 'sets the proper device line' do
      expect(line.identifier).to eq(line_identifier)
    end

    context 'with serial as identifier (no device_identifier)' do
      let(:second_device) { Device.last }
      it 'sets the serial as the devices identifier' do
        receiver = AssetReceiver.new @attrs.merge(device_identifier: nil)
        receiver.receive
        expect(second_device.identifier).to eq(serial)
      end
    end

    context 'without serial as identifier' do
      it 'sets the device_identifier as identifier' do
        expect(device.identifier).to eq(device_identifier)
      end
    end
  end
end