require 'rails_helper'

describe ManagementScorecardController do
  let(:manager) { create :person, position: position }
  let(:manager_person_area) { create :person_area, person: manager, area: area, manages: true }
  let(:position) { create :position, permissions: [scorecard_permission] }
  let(:scorecard_permission) { create :permission, key: 'area_management_scorecard' }

  before { CASClient::Frameworks::Rails::Filter.fake(manager.email) }

  context 'GET :management_scorecard' do
    before { get :management_scorecard }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the management_scorecard template' do
      expect(response).to render_template :management_scorecard
    end
  end
end