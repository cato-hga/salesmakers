require 'rails_helper'

describe DocusignConnectController do

  context 'new hire paperwork' do
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

    let!(:sysadmin) { create :person, display_name: 'System Administrator' }

    describe 'when the candidate completes the paperwork' do
      subject {
        post :incoming, candidate_completion_xml, format: :xml
        job_offer_detail.reload
      }

      it 'returns a success response' do
        subject
        expect(response).to be_success
      end

      it 'sets the candidate status to paperwork_completed_by_candidate' do
        subject
        expect(job_offer_detail.candidate.paperwork_completed_by_candidate?).to be_truthy
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
        expect(LogEntry.first.action).to eq('signed_nhp')
        expect(LogEntry.first.comment).to eq('Candidate')
      end
    end

    describe 'when the advocate completes the paperwork' do
      subject {
        post :incoming, advocate_completion_xml, format: :xml
        job_offer_detail.reload
      }

      it 'returns a success response' do
        subject
        expect(response).to be_success
      end

      it 'sets the candidate status to paperwork_completed_by_advocate' do
        subject
        expect(job_offer_detail.candidate.paperwork_completed_by_advocate?).to be_truthy
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
        expect(LogEntry.first.action).to eq('signed_nhp')
        expect(LogEntry.first.comment).to eq('Advocate')
      end
    end

    describe 'when HR completes the paperwork' do

      subject {
        job_offer_detail.candidate.onboarded!
        job_offer_detail.reload
        post :incoming, hr_completion_xml, format: :xml
        job_offer_detail.reload
      }

      it 'returns a success response' do
        subject
        expect(response).to be_success
      end

      it 'updates the job offer detail with the completion date/time' do
        subject
        expect(job_offer_detail.completed).to eq(Time.parse('2015-03-11T08:49:43.747 -0700'))
      end

      it 'sets the candidate status to paperwork_completed_by_hr' do
        subject
        expect(job_offer_detail.candidate.paperwork_completed_by_hr?).to be_falsey
        expect(job_offer_detail.candidate.onboarded?).to be_truthy
      end

      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
        expect(LogEntry.first.action).to eq('signed_nhp')
        expect(LogEntry.first.comment).to eq('HR')
      end
    end
  end

  describe 'notice of separation' do

  end

end