require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Device, :type => :model do

  it { should ensure_length_of(:identifier).is_at_least(4) }
  it { should ensure_length_of(:serial).is_at_least(6) }
  it { should validate_presence_of(:device_model) }
  it { should validate_uniqueness_of(:line_id) }

  let!(:device) { create :device, line: line, device_model: device_model }
  let(:device_two) { build :device }
  let(:line) { create :line }
  let(:device_model) { create :device_model }

  describe '#manufacturer_name' do
    it 'should return the device manufacturers name' do
      expect(device.manufacturer_name).to eq(device_model.device_manufacturer.name)
    end
  end

  describe '#model_name' do
    it 'should return the device model name' do
      expect(device.model_name).to eq(device_model.model_name)
    end
  end

  describe '#technology_service_provider' do
    it 'should return the service provider of the device' do
      expect(device.technology_service_provider.name).to eq(line.technology_service_provider.name)
    end
  end

  describe 'uniqueness validations' do
    it 'should validate uniqueness of serial' do
      expect(device_two).not_to be_valid
    end
  end

  describe 'creation with non-alphanumeric characters' do
    let(:serial) { '11^&22-334!4-55@66' }
    let(:identifier) { '6@6**5(5443-32+2$11' }

    it 'strips special characters from serial numbers' do
      stripped_device = create :device,
                               serial: serial,
                               identifier: serial
      expect(stripped_device.serial).to eq('112233445566')
    end

    it 'strips special characters from identifier' do
      stripped_device = create :device,
                               serial: serial,
                               identifier: identifier
      expect(stripped_device.identifier).to eq('665544332211')
    end
  end
end