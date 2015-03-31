require 'rails_helper'

describe DocusignConnectController do
  let(:candidate_completion_xml) {
    {
        "EnvelopeStatus" => {
            "RecipientStatuses" => {
                "RecipientStatus" => [
                    {
                        "Signed" => "2015-03-09T08:49:43.747",
                    },
                    {},
                    {}
                ]
            },
            "EnvelopeID" => "ea558d7e-39a4-482c-b0d1-2142cb521689"
        },
        "TimeZoneOffset" => "-7"
    }.to_xml(root: 'DocuSignEnvelopeInformation')
  }

  let(:advocate_completion_xml) {
    {
        "EnvelopeStatus" => {
            "RecipientStatuses" => {
                "RecipientStatus" => [
                    {
                        "Signed" => "2015-03-09T08:49:43.747",
                    },
                    {
                        "Signed" => "2015-03-10T08:49:43.747",
                    },
                    {}
                ]
            },
            "EnvelopeID" => "ea558d7e-39a4-482c-b0d1-2142cb521689"
        },
        "TimeZoneOffset" => "-7"
    }.to_xml(root: 'DocuSignEnvelopeInformation')
  }

  let(:hr_completion_xml) {
    {
        "EnvelopeStatus" => {
            "RecipientStatuses" => {
                "RecipientStatus" => [
                    {
                        "Signed" => "2015-03-09T08:49:43.747",
                    },
                    {
                        "Signed" => "2015-03-10T08:49:43.747",
                    },
                    {
                        "Signed" => "2015-03-11T08:49:43.747",
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

  describe 'when the candidate completes the paperwork' do
    before do
      post :incoming, candidate_completion_xml, format: :xml
      job_offer_detail.reload
    end

    it 'returns a success response' do
      expect(response).to be_success
    end

    it 'sets the candidate status to paperwork_completed_by_candidate' do
      expect(job_offer_detail.candidate.paperwork_completed_by_candidate?).to be_truthy
    end
  end

  describe 'when the advocate completes the paperwork' do
    before do
      post :incoming, advocate_completion_xml, format: :xml
      job_offer_detail.reload
    end

    it 'returns a success response' do
      expect(response).to be_success
    end

    it 'sets the candidate status to paperwork_completed_by_advocate' do
      expect(job_offer_detail.candidate.paperwork_completed_by_advocate?).to be_truthy
    end
  end

  describe 'when HR completes the paperwork' do

    before do
      job_offer_detail.candidate.onboarded!
      job_offer_detail.reload
      post :incoming, hr_completion_xml, format: :xml
      job_offer_detail.reload
    end

    it 'returns a success response' do
      expect(response).to be_success
    end

    it 'updates the job offer detail with the completion date/time' do
      expect(job_offer_detail.completed).to eq(Time.parse('2015-03-11T08:49:43.747 -0700'))
    end

    it 'sets the candidate status to paperwork_completed_by_hr' do
      expect(job_offer_detail.candidate.paperwork_completed_by_hr?).to be_falsey
      expect(job_offer_detail.candidate.onboarded?).to be_truthy
    end
  end
end