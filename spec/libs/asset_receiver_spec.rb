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
        contract_end_date: (Date.today + 1.year).strftime('%m/%d/%Y')
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
      expect(invalid_receiver).not_to be_valid
      expect(invalid_receiver.errors[:line_identifier].count).to eq(1)
    end
    it 'do not pass when line identifier is present but service provider is not' do
      invalid_receiver = AssetReceiver.new @attrs.merge(service_provider: nil)
      expect(invalid_receiver).not_to be_valid
      expect(invalid_receiver.errors[:service_provider].count).to eq(1)
    end
    it 'do not pass when a contract end date is present but line_identifier is not' do
      invalid_receiver = AssetReceiver.new @attrs.merge(line_identifier: nil)
      expect(invalid_receiver).not_to be_valid
      expect(invalid_receiver.errors[:line_identifier].count).to eq(1)
    end
    it 'do not pass when a line identifier is present but a contract end date is not' do
      invalid_receiver = AssetReceiver.new @attrs.merge(contract_end_date: nil)
      expect(invalid_receiver).not_to be_valid
      expect(invalid_receiver.errors[:contract_end_date].count).to eq(2)
    end
    it 'require a serial' do
      invalid_receiver = AssetReceiver.new @attrs.merge(serial: nil)
      expect(invalid_receiver).not_to be_valid
      expect(invalid_receiver.errors[:serial].count).to eq(1)
    end
    it 'require a device model' do
      invalid_receiver = AssetReceiver.new @attrs.merge(device_model: nil)
      expect(invalid_receiver).not_to be_valid
      expect(invalid_receiver.errors[:device_model].count).to eq(1)
    end
    it 'allow nil values for line and service provider and contract end date' do
      valid_receiver = AssetReceiver.new @attrs.merge(line_identifier: nil, service_provider: nil, contract_end_date: nil)
      expect(valid_receiver).to be_valid
    end
    it 'requires a creator (person)' do
      invalid_receiver = AssetReceiver.new @attrs.merge(creator: nil)
      expect(invalid_receiver).not_to be_valid
      expect(invalid_receiver.errors[:creator].count).to eq(1)
    end
    it 'does not pass with an invalid date' do
      invalid_receiver = AssetReceiver.new @attrs.merge(contract_end_date: '13/20/2014')
      expect(invalid_receiver).not_to be_valid
      expect(invalid_receiver.errors[:contract_end_date].count).to eq(1)
    end
    it 'passes with a blank string as a date' do
      valid_receiver = AssetReceiver.new @attrs.merge(contract_end_date: '', service_provider: nil, line_identifier: nil)
      expect(valid_receiver).to be_valid
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
      let(:new_serial) { '9876543' }
      it 'sets the serial as the devices identifier' do
        receiver = AssetReceiver.new @attrs.merge(device_identifier: nil, serial: new_serial, line_identifier: '4444444444')
        receiver.receive
        expect(second_device.identifier).to eq(new_serial)
      end
    end

    context 'without serial as identifier' do
      it 'sets the device_identifier as identifier' do
        expect(device.identifier).to eq(device_identifier)
      end
    end
  end
end