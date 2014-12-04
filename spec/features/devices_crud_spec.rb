require 'rails_helper'

describe 'Devices CRUD actions' do

  describe 'GET index'

  describe 'GET show' do
    context 'for all devices' do
      let(:device) { create :device }
      before(:each) do
        visit device_path device
      end

      it 'should have the devices serial number' do
        expect(page).not_to have_content(device.serial)
      end

      it 'should have a picture of the device'
      it 'should have a secondary identifier, if applicable'
      it 'should have the devices model'
      it 'should show log entries'
    end

    context 'for deployed devices' do
      it 'should have the "Deployed" state'
      it 'should show the latest deployment (at least)'
      it 'should have the option to write-off'
      it 'should have the option to recoup'
    end

    context 'for written-off devices' do
      it 'should indicate that the device is written off'
    end

    context 'for devices in inventory' do
      it 'should have the option to deploy'
      it 'should have the option to write-off'
    end

    context 'for devices with a line attached' do
      it 'should have the devices line'
      it 'should have the devices line_state'
      it 'should have the devices provider image'
    end

    context 'for devices without a line attached' do
      it 'should display "None" for the line'
    end
  end
end