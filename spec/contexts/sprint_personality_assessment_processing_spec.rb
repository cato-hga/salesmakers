require 'rails_helper'
require_relative '../../app/contexts/sprint_personality_assessment_processing'

describe SprintPersonalityAssessmentProcessing do
  include ActiveJob::TestHelper


  let!(:personality) {
    File.new(Rails.root.join('spec', 'fixtures', '20150406_-_20150406_Candidate_Score_-_Jobside_(No_EEO)_SalesMakers_Inc_(_SAL33701FL_)_S2P_United_States_S2P_US.xls'))
  }
  let(:processor) { described_class.new(File.absolute_path(personality.path)) }

  context 'updating scores' do
    let!(:passing_candidate) { create :candidate,
                                      email: 'test1@test.com',
                                      personality_assessment_score: nil,
                                      personality_assessment_status: :incomplete,
                                      personality_assessment_completed: false }
    let!(:failing_candidate) { create :candidate, email: 'test2@test.com',
                                      personality_assessment_score: nil,
                                      personality_assessment_status: :incomplete,
                                      personality_assessment_completed: false }
    let!(:nomatch_candidate) { create :candidate, email: 'test100@test.com',
                                      personality_assessment_score: nil,
                                      personality_assessment_status: :incomplete,
                                      personality_assessment_completed: false }
    let!(:administrator) { create :person, email: 'retailingw@retaildoneright.com' }
    let!(:skipped_candidate) { create :candidate, email: 'test4@test.com',
                                      personality_assessment_score: nil,
                                      personality_assessment_status: :incomplete,
                                      personality_assessment_completed: false }
    let!(:candidate_with_score) { create :candidate, email: 'test5@test.com',
                                         personality_assessment_score: 80,
                                         personality_assessment_status: :qualified,
                                         personality_assessment_completed: true }
    let!(:job_offer) { create :job_offer_detail, candidate: candidate_with_score }
    let!(:interview) { create :interview_schedule, candidate: failing_candidate, active: true }

    it 'updates the passing and failing status for matched candidates' do
      expect(passing_candidate.passed_personality_assessment?).to eq(nil)
      expect(failing_candidate.passed_personality_assessment?).to eq(nil)
      expect(nomatch_candidate.passed_personality_assessment?).to eq(nil)
      expect(skipped_candidate.passed_personality_assessment?).to eq(nil)
      expect(candidate_with_score.passed_personality_assessment?).to eq(true)
      processor
      passing_candidate.reload
      failing_candidate.reload
      nomatch_candidate.reload
      skipped_candidate.reload
      candidate_with_score.reload
      expect(passing_candidate.passed_personality_assessment?).to eq(true)
      expect(failing_candidate.passed_personality_assessment?).to eq(false)
      expect(nomatch_candidate.passed_personality_assessment?).to eq(nil)
      expect(skipped_candidate.passed_personality_assessment?).to eq(false)
      expect(candidate_with_score.passed_personality_assessment?).to eq(true)
    end

    it 'updates the assessment completion for matched candidates' do
      expect(passing_candidate.personality_assessment_completed).to eq(false)
      expect(failing_candidate.personality_assessment_completed).to eq(false)
      expect(nomatch_candidate.personality_assessment_completed).to eq(false)
      expect(skipped_candidate.personality_assessment_completed).to eq(false)
      expect(candidate_with_score.personality_assessment_completed).to eq(true)
      processor
      passing_candidate.reload
      failing_candidate.reload
      nomatch_candidate.reload
      skipped_candidate.reload
      candidate_with_score.reload
      expect(passing_candidate.personality_assessment_completed).to eq(true)
      expect(failing_candidate.personality_assessment_completed).to eq(true)
      expect(nomatch_candidate.personality_assessment_completed).to eq(false)
      expect(skipped_candidate.personality_assessment_completed).to eq(true)
      expect(candidate_with_score.personality_assessment_completed).to eq(true)
    end

    it 'updates the assessment scores for matched candidates' do
      expect(passing_candidate.personality_assessment_score).to eq(nil)
      expect(failing_candidate.personality_assessment_score).to eq(nil)
      expect(nomatch_candidate.personality_assessment_score).to eq(nil)
      expect(candidate_with_score.personality_assessment_score).to eq(80)
      processor
      passing_candidate.reload
      failing_candidate.reload
      nomatch_candidate.reload
      skipped_candidate.reload
      candidate_with_score.reload
      expect(passing_candidate.personality_assessment_score).to eq(81.16)
      expect(failing_candidate.personality_assessment_score).to eq(18.58)
      expect(nomatch_candidate.personality_assessment_score).to eq(nil)
      expect(skipped_candidate.personality_assessment_score).to eq(7.21)
      expect(candidate_with_score.personality_assessment_score).to eq(80)
    end

    it 'updates the personality assessment status for matched candidates' do
      expect(passing_candidate.personality_assessment_status).to eq("incomplete")
      expect(failing_candidate.personality_assessment_status).to eq("incomplete")
      expect(nomatch_candidate.personality_assessment_status).to eq("incomplete")
      expect(skipped_candidate.personality_assessment_status).to eq("incomplete")
      expect(candidate_with_score.personality_assessment_status).to eq("qualified")
      processor
      passing_candidate.reload
      failing_candidate.reload
      nomatch_candidate.reload
      skipped_candidate.reload
      candidate_with_score.reload
      expect(passing_candidate.personality_assessment_status).to eq("qualified")
      expect(failing_candidate.personality_assessment_status).to eq("disqualified")
      expect(nomatch_candidate.personality_assessment_status).to eq("incomplete")
      expect(skipped_candidate.personality_assessment_status).to eq("disqualified")
      expect(candidate_with_score.personality_assessment_status).to eq("qualified")
    end

    it 'emails the candidates who failed' do
      expect {
        processor
        perform_enqueued_jobs do
          ActionMailer::DeliveryJob.new.perform(*enqueued_jobs.first[:args])
        end
      }.to change(ActionMailer::Base.deliveries, :count).by(1)
    end

    it 'generates instances of unmatched candidates and their scores' do
      expect { processor }.to change(UnmatchedCandidate, :count).by(1)
    end

    it 'creates a log entry for passing and failing' do
      expect { processor }.to change(LogEntry, :count).by(6)
    end
    it 'deletes interviews scheduled for an employee' do
      expect {
        processor
        interview.reload
      }.to change(interview, :active).to(false)
    end

  end

  context 'paperwork sending' do
    let!(:candidate_with_paperwork) { create :candidate, email: 'test5@test.com',
                                             personality_assessment_score: 80,
                                             personality_assessment_status: :qualified,
                                             personality_assessment_completed: true }
    let!(:passing_candidate_no_paperwork) { create :candidate, email: 'test1@test.com',
                                                   personality_assessment_score: nil,
                                                   personality_assessment_status: :incomplete,
                                                   personality_assessment_completed: false }
    let!(:failing_candidate_no_paperwork) { create :candidate, email: 'test2@test.com',
                                                   personality_assessment_score: nil,
                                                   personality_assessment_status: :incomplete,
                                                   personality_assessment_completed: false }
    let!(:job_offer) { create :job_offer_detail, candidate: candidate_with_paperwork }

    it 'sends paperwork if the candidate is candidate is confirmed and passes the assessment' do
      expect {
        processor
        candidate_with_paperwork.reload
        passing_candidate_no_paperwork.reload
      }.to change(JobOfferDetail, :count).by(1)
    end
    it 'does not send paperwork if the candidate fails, and is confirmed' do
      expect {
        processor
        candidate_with_paperwork.reload
        passing_candidate_no_paperwork.reload
      }.to change(JobOfferDetail, :count).by(1)
    end
    it 'does not send paperwork twice'
  end

end