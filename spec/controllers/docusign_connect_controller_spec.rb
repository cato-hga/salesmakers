require 'rails_helper'

describe DocusignConnectController do
  let(:xml) {
    {
        "EnvelopeStatus" => {
            "RecipientStatuses" => {
                "RecipientStatus" => [
                    {
                        "Signed" => "2015-03-09T08:49:43.747",
                    }
                ]
            },
            "EnvelopeID" => "ea558d7e-39a4-482c-b0d1-2142cb521689"
        },
        "TimeZoneOffset" => "-7"
    }.to_xml(root: 'DocuSignEnvelopeInformation')
  }
  let!(:job_offer_detail) {
    create :job_offer_detail, envelope_guid: 'ea558d7e-39a4-482c-b0d1-2142cb521689'
  }

  before do
    post :incoming, xml, format: :xml
    job_offer_detail.reload
  end

  it 'returns a success response' do
    expect(response).to be_success
  end

  it 'updates the job offer detail with the completion date/time' do
    expect(job_offer_detail.completed).to eq(Time.parse('2015-03-09T08:49:43.747 -0700'))
  end

  it 'sets the candidate status to paperwork_completed' do
    expect(job_offer_detail.candidate.paperwork_completed?).to be_truthy
  end

end