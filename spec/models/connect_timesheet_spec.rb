require 'rails_helper'

describe ConnectTimesheet do
  describe 'determination of LocationArea' do
    let!(:vonage_retail_project) { create :project, name: 'Vonage Retail' }
    let!(:vonage_events_project) { create :project, name: 'Vonage Events' }

    context 'for Vonage Events' do
      let(:vonage_events_timesheet) { ConnectTimesheet.find '38EA3B7B4EFDC59C014F038852665F62' }

      it 'returns the correct project' do
        expect(vonage_events_timesheet.project).to eq vonage_events_project
      end
    end

    context 'for Vonage Retail' do
      let(:vonage_retail_timesheet) { ConnectTimesheet.find '38EA3B7B4AE89C48014AF41DDA85734F' }

      it 'returns the correct project' do
        expect(vonage_retail_timesheet.project).to eq vonage_retail_project
      end
    end
  end
end