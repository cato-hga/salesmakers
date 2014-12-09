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
  let(:device_model) { build_stubbed :device_model }
  let(:service_provider) { build_stubbed :technology_service_provider }
  let(:line_identifier) { '5555555555' }
  let(:serial) { '123456789' }
  let(:device_identifier) { '98765431' }
  let(:creator) { build_stubbed :person }
  let(:receiver) { AssetReceiver.new @attrs }

  it 'is valid with the correct inputs' do
    expect(receiver).to be_valid
  end

  it 'is invalid when service provider is present but line identifier is not' do
    invalid_receiver = AssetReceiver.new @attrs.merge(line_identifier: nil)
    expect(invalid_receiver).not_to be_valid_line_identifier
    expect(invalid_receiver).not_to be_valid
  end

  it 'is invalid when line identifier is present but service provider is not' do
    invalid_receiver = AssetReceiver.new @attrs.merge(service_provider: nil)
    expect(invalid_receiver).not_to be_valid_service_provider
    expect(invalid_receiver).not_to be_valid
  end

  it 'is invalid when a contract end date is present but line_identifier is not' do
    invalid_receiver = AssetReceiver.new @attrs.merge(line_identifier: nil)
    expect(invalid_receiver).not_to be_valid_line_identifier
    expect(invalid_receiver).not_to be_valid
  end

  it 'is invalid when a line identifier is present but a contract end date is not' do
    invalid_receiver = AssetReceiver.new @attrs.merge(contract_end_date: nil)
    expect(invalid_receiver).not_to be_valid_contract_end_date
    expect(invalid_receiver).not_to be_valid
  end

  it 'requires a serial' do
    invalid_receiver = AssetReceiver.new @attrs.merge(serial: nil)
    expect(invalid_receiver).not_to be_valid_serial
    expect(invalid_receiver).not_to be_valid
  end

  it 'requires a device model' do
    invalid_receiver = AssetReceiver.new @attrs.merge(device_model: nil)
    expect(invalid_receiver).not_to be_valid_device_model
    expect(invalid_receiver).not_to be_valid
  end

  it 'allows nil values for line and service provider and contract end date' do
    valid_receiver = AssetReceiver.new @attrs.merge(line_identifier: nil, service_provider: nil, contract_end_date: nil)
    expect(valid_receiver).to be_valid_service_provider
    expect(valid_receiver).to be_valid_contract_end_date
    expect(valid_receiver).to be_valid_line_identifier
    expect(valid_receiver).to be_valid
  end

  it 'requires a creator (person)' do
    invalid_receiver = AssetReceiver.new @attrs.merge(creator: nil)
    expect(invalid_receiver).not_to be_valid_creator
    expect(invalid_receiver).not_to be_valid
  end

  it 'sets the device identifier if provided' do
    expect(receiver.device_identifier).to eq(device_identifier)
  end

  it 'uses the devices serial as device_identifier if no identifier is provided' do
    receiver = AssetReceiver.new @attrs.merge(device_identifier: nil)
    expect(receiver.device_identifier).to eq(serial)
  end

  it 'creates a device' do
    expect { receiver.receive }.to change(Device, :count).by(1)
  end

  it 'creates a line' do
    expect { receiver.receive }.to change(Line, :count).by(1)
  end

  it 'creates a log entry for receiving'
  it 'sets the proper service provider'
  it 'sets the proper manufacturer and model'
  it 'assigns the proper device serial'
  it 'assigns the proper device line'
  it 'assigns the proper device device_identifier identifier, if required'
end