require 'rails_helper'

describe EmailAttachmentAcceptorJob do
  let!(:uqube) {
    File.new(Rails.root.join('spec', 'fixtures', 'UQube Import for FTP.xlsx'))
  }
  let!(:personality) {
    File.new(Rails.root.join('spec', 'fixtures', '20150406_-_20150406_Candidate_Score_-_Jobside_(No_EEO)_SalesMakers_Inc_(_SAL33701FL_)_S2P_United_States_S2P_US.xls'))
  }
  describe '#perform' do
    it 'recognizes uqube files' do
      expect(VonageAccountStatusChange).to receive(:new)
      expect { EmailAttachmentAcceptorJob.perform_later File.absolute_path(uqube.path) }.to raise_error(NoMethodError)
    end

    it 'recognizes personality assessment files' do
      expect(SprintPersonalityAssessmentProcessing).to receive(:new)
      EmailAttachmentAcceptorJob.perform_later File.absolute_path(personality.path)
    end
  end
end