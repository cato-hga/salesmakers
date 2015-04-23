require 'rails_helper'

RSpec.describe AssetApprovalsController, :type => :controller do

  # describe 'GET new' do
  #   before {
  #     get :approval
  #   }
  #   it 'returns a success setting' do
  #     expect(response).to be_success
  #     expect(response).to render_template(:approval)
  #   end
  # end

  describe 'POST create' do
    let(:approving_person) { create :person }
    let(:denying_person) { create :person }

    context 'approving' do
      before {
        patch :approve,
              person_id: approving_person.id

        approving_person.reload
      }

      it 'updates the tablet approval status for the person' do
        expect(approving_person.vonage_tablet_approval_status).to eq('approved')
      end

      it 'redirects to the approval page' do
        expect(response).to render_template(:approval)
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
      end
    end

  end
end
