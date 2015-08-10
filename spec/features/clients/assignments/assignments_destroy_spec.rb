require 'rails_helper'

describe 'destroying WorkmarketAssignments' do
  let!(:project) { create :project, client: client_rep.client }
  let!(:permission_show) { create :permission, key: 'workmarket_assignment_show' }
  let!(:permission_destroy) { create :permission, key: 'workmarket_assignment_destroy' }
  let!(:assignment) { create :workmarket_assignment, project: project }
  let!(:attachment) {
    create :workmarket_attachment,
           workmarket_assignment: assignment
  }
  let!(:field) { create :workmarket_field, workmarket_assignment: assignment }
  let!(:location) { create :workmarket_location, workmarket_location_num: assignment.workmarket_location_num }

  before do
    page.set_rack_session client_representative_id: client_rep.id
    visit client_access_worker_assignment_path(assignment)
  end

  context 'for those with permission' do
    let!(:client_rep) { create :client_representative, permissions: [permission_show, permission_destroy] }

    subject do
      click_on 'destroy_assignment'
    end

    it 'destroys the assignment' do
      expect {
        subject
      }.to change(WorkmarketAssignment, :count).by(-1)
    end

    it 'destroys the attachments' do
      expect {
        subject
      }.to change(WorkmarketAttachment, :count).by(-1)
    end

    it 'destroys the fields' do
      expect {
        subject
      }.to change(WorkmarketField, :count).by(-1)
    end
  end

  context 'for those without permission' do
    let!(:client_rep) { create :client_representative, permissions: [permission_show] }

    it 'has no delete button' do
      expect(page).not_to have_selector('#destroy_assignment')
    end
  end

end