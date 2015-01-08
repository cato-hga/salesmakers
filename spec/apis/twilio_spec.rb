require 'rails_helper'
require 'apis/gateway'

describe 'SMS Gateway API' do
  let(:gateway) { Gateway.new }

  it 'should send a text message', vcr: true do
    gateway.send_text '8635214572', 'This is a test message'
  end

end