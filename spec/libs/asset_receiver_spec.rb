require 'rails_helper'

RSpec.describe 'Asset Receiver' do

  let(:device_model) { build_stubbed :device_model }
  let(:service_provider) { build_stubbed :technology_service_provider }
  let(:line_identifier) { '5555555555' }
  let(:serial) { '123456789' }
  let(:secondary) { '98765431' }
  let(:receiver) { AssetReceiver.new device_model,
                                     service_provider,
                                     line_identifier,
                                     serial,
                                     secondary }

  it 'is valid with the correct inputs' do
    expect(receiver).to be_valid
  end

  it 'is invalid when service provider is present but line identifier is not' do
    invalid_receiver = AssetReceiver.new device_model,
                                         service_provider,
                                         nil,
                                         serial,
                                         secondary
    expect(invalid_receiver).not_to be_valid_service_provider
    expect(invalid_receiver).not_to be_valid_line_identifier
    expect(invalid_receiver).not_to be_valid
  end

  it 'is invalid when line identifier is present but service provider is not' do
    invalid_receiver = AssetReceiver.new device_model,
                                         nil,
                                         line_identifier,
                                         serial,
                                         secondary
    expect(invalid_receiver).not_to be_valid_service_provider
    expect(invalid_receiver).not_to be_valid_line_identifier
    expect(invalid_receiver).not_to be_valid
  end

  it 'requires a serial' do
    invalid_receiver = AssetReceiver.new device_model,
                                         service_provider,
                                         line_identifier,
                                         nil,
                                         secondary
    expect(invalid_receiver).not_to be_valid_serial
    expect(invalid_receiver).not_to be_valid
  end

  it 'requires a device model' do
    invalid_receiver = AssetReceiver.new nil,
                                         service_provider,
                                         line_identifier,
                                         serial,
                                         secondary
    expect(invalid_receiver).not_to be_valid_device_model
    expect(invalid_receiver).not_to be_valid
  end

  it 'allows nil values for line and service provider' do
    valid_receiver = AssetReceiver.new device_model,
                                       nil,
                                       nil,
                                       serial,
                                       secondary
    expect(valid_receiver).to be_valid_service_provider
    expect(valid_receiver).to be_valid_line_identifier
    expect(valid_receiver).to be_valid
  end

  it 'creates a device'
  it 'creates a line'
  it 'creates a log entry for receiving'
  it 'sets the proper service provider'
  it 'sets the proper manufacturer and model'
  it 'assigns the proper device serial'
  it 'assigns the proper device line'
  it 'assigns the proper device secondary identifier, if required'
end