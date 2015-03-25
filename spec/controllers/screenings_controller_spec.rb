require 'rails_helper'

describe ScreeningsController do
  let(:person) { create :person }
  let!(:candidate) { create :candidate, person: person }

  before { CASClient::Frameworks::Rails::Filter.fake(create(:person).email) }

  describe 'GET edit' do
    before do
      allow(controller).to receive(:policy).and_return double(edit?: true)
      get :edit,
          person_id: person.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the edit template' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT update' do
    before do
      allow(controller).to receive(:policy).and_return double(update?: true)
      put :update,
          person_id: person.id,
          screening: {
              sex_offender_check: '2',
              public_background_check: '1',
              private_background_check: '3',
              drug_screening: '3'
          }
    end

    it 'creates a log entry for the person and candidate' do
      expect(LogEntry.where(trackable_type: 'Candidate').count).to eq(1)
      expect(LogEntry.where(trackable_type: 'Person').count).to eq(1)
    end

    it 'redirects to people#index' do
      expect(response).to redirect_to(people_path)
    end
  end
end