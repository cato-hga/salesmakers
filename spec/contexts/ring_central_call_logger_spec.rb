require 'rails_helper'
require 'apis/ring_central'

describe RingCentralCallLogger do
  subject { described_class.log }

  let(:calls) {
    [{
        "uri" => "https://platform.devtest.ringcentral.com/restapi/v1.0/account/132311004/call-log/AQZ0gICxR0c0o6o?view=Simple",
        "id" => "AQZ0gICxR0c0o6o",
        "sessionId" => "12394091004",
        "startTime" => "2015-09-23T14:20:58.000Z",
        "duration" => 7,
        "type" => "Voice",
        "direction" => "Outbound",
        "action" => "RingOut PC",
        "result" => "Call connected",
        "to" => {
            "phoneNumber" => "+16505496111",
            "name" => "Anthony Atkinson",
            "location" => "Redwood City, CA"
        },
        "from" => {
            "phoneNumber" => "+18635214572",
            "name" => "Anthony Atkinson"
        }
    }]
  }

  before do
    allow_any_instance_of(RingCentral).to receive(:call_logs).and_return(calls)
  end

  it 'saves call logs' do
    expect { subject }.to change(RingCentralCall, :count).by_at_least 1
  end
end