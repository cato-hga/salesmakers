require 'rails_helper'

RSpec.describe AssetApprovalsController, :type => :controller do

  let(:manager) { create :person }
  before {
    allow(controller).to receive(:policy).and_return double(approval?: true)
    CASClient::Frameworks::Rails::Filter.fake(manager.email)
  }

  describe 'GET new' do
    before {
      get :approval
    }
    it 'returns a success setting' do
      expect(response).to be_success
      expect(response).to render_template(:approval)
    end
  end

  describe 'POST create' do

    context 'Vonage asset' do
      let(:approving_person) { create :person }
      let(:denying_person) { create :person }
      let!(:project) { create :project, name: 'Vonage Retail' }
      let!(:area) { create :area, project: project }
      let!(:person_area_one) { create :person_area, area: area, person: approving_person }
      let!(:person_area_two) { create :person_area, area: area, person: denying_person }
      context 'approving' do
        before {
          patch :approve,
                person_id: approving_person.id

          approving_person.reload
        }
        it 'updates the tablet approval status for the person' do
          expect(approving_person.vonage_tablet_approval_status).to eq('approved')
          expect(approving_person.sprint_prepaid_asset_approval_status).to eq('prepaid_no_decision')
        end
        it 'redirects to the approval page' do
          expect(response).to redirect_to(asset_approval_path)
        end
      end
      context 'denying' do
        before {
          patch :deny,
                person_id: denying_person.id
          denying_person.reload
        }
        it 'updates the tablet approval status for the person' do
          expect(denying_person.vonage_tablet_approval_status).to eq('denied')
          expect(denying_person.sprint_prepaid_asset_approval_status).to eq('prepaid_no_decision')
        end

        it 'redirects to the approval page' do
          expect(response).to redirect_to(asset_approval_path)
        end
      end
    end

    context 'Sprint Prepaid asset' do
      let!(:approving_person) { create :person }
      let!(:denying_person) { create :person }
      let!(:project) { create :project, name: 'Sprint Retail' }
      let!(:area) { create :area, project: project }
      let!(:person_area_one) { create :person_area, area: area, person: approving_person }
      let!(:person_area_two) { create :person_area, area: area, person: denying_person }
      context 'approving' do
        before {
          patch :approve,
                person_id: approving_person.id
          approving_person.reload
        }
        it 'updates the sprint prepaid approval status for the person' do
          expect(approving_person.sprint_prepaid_asset_approval_status).to eq('prepaid_approved')
          expect(approving_person.vonage_tablet_approval_status).to eq('no_decision')
        end
        it 'redirects to the approval page' do
          expect(response).to redirect_to(asset_approval_path)
        end
      end
      context 'denying' do
        before {
          patch :deny,
                person_id: denying_person.id
          denying_person.reload
        }
        it 'updates the sprint prepaid approval status for the person' do
          expect(denying_person.sprint_prepaid_asset_approval_status).to eq('prepaid_denied')
          expect(denying_person.vonage_tablet_approval_status).to eq('no_decision')
        end

        it 'redirects to the approval page' do
          expect(response).to redirect_to(asset_approval_path)
        end
      end
    end
  end
end
