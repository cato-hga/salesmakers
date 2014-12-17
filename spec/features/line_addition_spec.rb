require 'rails_helper'

describe 'Line Addition' do

  context 'for single lines' do
    context 'success' do
      let!(:service_provider) { create :technology_service_provider }
      let!(:creator) { create :person }
      let(:contract_end_date) { Date.today + 1.year }
      let!(:line_state) { create :line_state, name: 'Active' }
      subject {
        visit new_line_path
        fill_in :line_contract_end_date, with: contract_end_date.strftime('%m/%d/%Y')
        select service_provider.name, from: 'line_technology_service_provider_id'
        fill_in :line_identifier, with: '5555555555'
        click_on 'Receive'
      }
      it 'creates a line' do
        expect { subject }.to change(Line, :count).by(1)
      end
      it 'creates a log entry' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
      it 'assigns the correct contract end date' do
        subject
        new_line = Line.first
        expect(new_line.contract_end_date).to eq(contract_end_date)
      end
      it 'assigns the "active" status to the new line' do
        subject
        new_line = Line.first
        expect(new_line.line_states).to include(line_state)
      end
      it 'assigns the correct provider' do
        subject
        new_line = Line.first
        expect(new_line.technology_service_provider).to eq(service_provider)
      end
      it 'redirects to lines#index' do
        subject
        expect(page).to have_content(contract_end_date.strftime('%m/%d/%Y'))
      end
    end
  end

  context 'for multiple lines' do

  end

end