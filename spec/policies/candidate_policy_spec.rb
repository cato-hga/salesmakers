require 'rails_helper'

describe CandidatePolicy do
  let!(:recruiter_one) { create :person, position: position }
  let!(:recruiter_two) { create :person }
  let(:position) { create :position, name: 'Advocate', permissions: [permission_view_all] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_view_all) { Permission.new key: 'candidate_view_all',
                                             permission_group: permission_group,
                                             description: 'Test Description' }
  let!(:candidate_one) { create :candidate, created_by: recruiter_one }
  let!(:candidate_two) { create :candidate, created_by: recruiter_two }

  # describe 'scopes' do
  #   it 'shows all candidates for someone with permission' do
  #     expect(Pundit.policy_scope(recruiter_one, Candidate.all).count).to eq(2)
  #   end
  #
  #   it 'shows only candidates created_by current person without permission' do
  #     expect(Pundit.policy_scope(recruiter_two, Candidate.all).count).to eq(1)
  #   end
  # end
end
