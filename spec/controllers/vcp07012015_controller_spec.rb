require 'rails_helper'

describe VCP07012015Controller do
  let(:project) { create :project, name: 'Vonage Retail' }
  let(:area) { create :area, project: project }
  let(:rep) { create :person }
  let!(:person_area) { create :person_area, area: area, person: rep }

  let!(:vonage_commission_period07012015) {
    create :vonage_commission_period07012015,
           hps_start: Date.today.beginning_of_month,
           hps_end: Date.today.end_of_month,
           vested_sales_start: Date.today.beginning_of_month - 1.month,
           vested_sales_end: Date.today.beginning_of_month - 1.day,
           cutoff: DateTime.now + 1.day
  }

  before do
    CASClient::Frameworks::Rails::Filter.fake(rep.email)
  end

  describe 'GET show' do
    before { get :show, person_id: rep.id }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the show template' do
      expect(response).to render_template :show
    end
  end
end
