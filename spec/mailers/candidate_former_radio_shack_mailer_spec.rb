require 'rails_helper'

describe CandidateFormerRadioShackMailer do

  describe 'vetting mailer' do
    let(:candidate) { create :candidate }
    let(:prescreen_answer) { create :prescreen_answer,
                                    former_employment_date_start: Date.today - 1.year,
                                    former_employment_date_end: Date.today - 6.months,
                                    store_number_city_state: '333, St Pete, Florida'
    }
    let(:mail) { CandidateFormerRadioShackMailer.vetting_mailer(candidate,
                                                                prescreen_answer.former_employment_date_start,
                                                                prescreen_answer.former_employment_date_end,
                                                                prescreen_answer.store_number_city_state
    ) }

    # it 'has the correct from address' do
    #   expect(mail.from).to eq(['sprintvetting@salesmakersinc.com'])
    # end
    # it 'has the correct subject' do
    #   expect(mail.subject).to eq('New SalesMakers, Inc Candidate Requiring Approval')
    # end
    # it 'ccs kevin and russ' do
    #   expect(mail.cc).to eq(['kevin@retaildoneright.com', 'rcushing@retaildoneright.com'])
    # end
    # it 'sends an email to the sprint rep' do
    #   expect(mail.to).to eq(['kelly.berard@radioshack.com'])
    # end
    it 'contains all relevant info' do
      source = mail.body.parts.find {|p| p.content_type.match /html/}.body.raw_source
      expect(source).to include(prescreen_answer.former_employment_date_start.to_s)
      expect(source).to include(prescreen_answer.former_employment_date_end.to_s)
      expect(source).to include(prescreen_answer.store_number_city_state)
      expect(source).to include(candidate.name)
    end
  end
end