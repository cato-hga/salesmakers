require 'rails_helper'

describe 'Reconciling a candidate' do

  let(:hr_admin) { create :person, position: position }
  let(:position) { create :position, name: 'Software Developer', permissions: [permission_create, permission_index] }
  let!(:candidate) { create :candidate }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.new key: 'candidate_create',
                                           permission_group: permission_group,
                                           description: 'Test Description' }
  let(:permission_index) { Permission.create key: 'candidate_index',
                                             description: 'Blah blah blah',
                                             permission_group: permission_group }

  describe 'for unauthorized users' do
    let(:unauth_person) { create :person, position: recruiter }
    let(:recruiter) { create :position, name: 'Advocate', permissions: [permission_create, permission_index] }


    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(unauth_person.email)
      visit candidate_path candidate
    end

    it "does not show the Reconciliation widget" do
      expect(page).not_to have_content 'Candidate Reconciliation'
    end
  end

  describe 'for authorized users' do
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(hr_admin.email)
      visit candidate_path candidate
    end

    it 'should have the reconciliation widget' do
      expect(page).to have_content 'Candidate Reconciliation'
    end

    describe 'updating' do

      before(:each) do
        select 'Working', from: :candidate_reconciliation_status
        click_on 'Reconcile'
      end

      it 'creates a reconciliation record' do
        expect(CandidateReconciliation.all.count).to eq(1)
        candidate.reload
        expect(candidate.candidate_reconciliations.last).to eq(CandidateReconciliation.first)
      end
      it 'sets the status to the dropdown option chosen' do
        expect(candidate.candidate_reconciliations.last.status).to eq('working')
      end
      it 'redirects to the candidate show page' do
        expect(page).to have_content candidate.name
      end
    end

  end

end