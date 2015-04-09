require 'rails_helper'

RSpec.describe CandidateDrugTestsController, :type => :controller do

  describe 'GET new' do
    let(:candidate) { create :candidate }
    before(:each) do
      allow(controller).to receive(:policy).and_return double(new?: true)
    end
    it 'returns a success status' do
      get :new, candidate_id: candidate.id
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:candidate) { create :candidate }
    let(:recruiter) { create :person }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
      allow(controller).to receive(:policy).and_return double(create?: true)
    end
    context 'a candidate who has not scheduled their drug test' do
      subject do
        post :create,
            candidate_id: candidate.id,
            candidate_drug_test: {
                scheduled: false,
                comments: 'N/A'
            }
      end

      it 'creates a Candidate Drug Test' do
        expect { subject }.to change(CandidateDrugTest, :count).by(1)
      end
      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
      it 'assigns correct attributes' do
        subject
        drug_test = CandidateDrugTest.first
        expect(drug_test.scheduled).to eq(false)
        expect(drug_test.comments).to eq('N/A')
        expect(drug_test.candidate).to eq(candidate)
      end
      it 'redirects to index' do
        subject
        expect(response).to redirect_to candidates_path
      end
    end

    context 'a candidate who has scheduled their drug test' do
      subject do
        post :create,
             candidate_id: candidate.id,
             candidate_drug_test: {
                 scheduled: true,
                 test_date: DateTime.now,
                 comments: 'N/A'
             }
      end

      it 'creates a Candidate Drug Test' do
        expect { subject }.to change(CandidateDrugTest, :count).by(1)
      end
      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
      it 'assigns correct attributes' do
        subject
        drug_test = CandidateDrugTest.first
        expect(drug_test.scheduled).to eq(true)
        expect(drug_test.comments).to eq('N/A')
        expect(drug_test.candidate).to eq(candidate)
      end
      it 'redirects to index' do
        subject
        expect(response).to redirect_to candidates_path
      end
    end

    context 'with previous information saved' do
      let!(:candidate_with_test) { create :candidate }
      let!(:time) { DateTime.now }
      let!(:drug_test) { create :candidate_drug_test, candidate: candidate_with_test, scheduled: false, comments: 'Old comment' }
      subject do
        post :create,
             candidate_id: candidate_with_test.id,
             candidate_drug_test: {
                 scheduled: true,
                 test_date: time,
                 comments: 'N/A'
             }
      end

      it 'deletes the old record and creates a new one in its place' do
        expect(candidate_with_test.candidate_drug_test.scheduled).to eq(false)
        expect(candidate_with_test.candidate_drug_test.comments).to eq('Old comment')
        subject
        candidate_with_test.reload
        expect(candidate_with_test.candidate_drug_test.scheduled).to eq(true)
        expect(candidate_with_test.candidate_drug_test.comments).to eq('N/A')
        expect(candidate_with_test.candidate_drug_test.test_date).to eq(Chronic.parse(time.to_s))
      end
    end
  end
end
