require 'rails_helper'

describe LinesController do

  describe 'GET index' do
    before { get :index }
    it 'should return a success status' do
      expect(response).to be_success
    end
    it 'should render the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET new' do
    before { get :new }
    it 'should return a success status' do
      expect(response).to be_success
    end
    it 'should render the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    context 'success (valid data)' do
      subject {
        post :create,
             line: {
                 technology_service_provider_id: service_provider.id,
                 identifier: line_identifier,
                 contract_end_date: contract_end_date
             }
      }
      let!(:service_provider) { create :technology_service_provider }
      let(:line_identifier) { '5555555555' }
      let(:contract_end_date) { Date.today + 1.year }
      let!(:line_state) { create :line_state, name: 'Active' }
      it 'creates a line' do
        expect { subject }.to change(Line, :count).by(1)
      end
      it 'creates log entries' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
      it 'should redirect to lines#index' do
        expect(subject).to redirect_to(lines_path)
      end
      it 'should assign the Active line_state'
    end

    context 'failure' do
      let!(:service_provider) { create :technology_service_provider }
      let(:invalid_line_identifier) { '5555555555' }
      let(:contract_end_date) { Date.today + 1.year }
      let!(:line_state) { create :line_state, name: 'Active' }
      context 'invalid data' do
        subject {
          post :create,
               line: {
                   contract_end_date: contract_end_date.strftime('%m/%d/%Y'),
                   technology_service_provider_id: service_provider.id,
                   line_identifier: invalid_line_identifier
               }
        }
        it 'presents an error when form is invalid' do
          subject
          expect(flash[:error]).to be_present
        end
        it 'should render the new template' do
          expect(subject).to redirect_to(new_line_path)
        end
      end
    end
  end
end