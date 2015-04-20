require 'rails_helper'

describe 'assignments index' do
  let!(:client_rep) { create :client_representative, permissions: [permission] }
  let!(:project) { create :project, client: client_rep.client }
  let!(:permission) { create :permission, key: 'workmarket_assignment_index' }
  let!(:assignment) { create :workmarket_assignment, project: project }
  let!(:attachment) { create :workmarket_attachment, workmarket_assignment: assignment }
  let!(:field) { create :workmarket_field, workmarket_assignment: assignment }
  let!(:location) { create :workmarket_location, workmarket_location_num: assignment.workmarket_location_num }

  before do
    page.set_rack_session client_representative_id: client_rep.id
  end

  context 'for those without permission to see SalesMakers-specific data' do
    before do
      visit client_access_worker_assignments_path
    end

    it 'shows the started datetime' do
      expect(page).to have_content(assignment.started.strftime('%m/%d %l:%M%P %Z'))
    end

    it 'shows the ended datetime' do
      expect(page).to have_content(assignment.ended.strftime('%m/%d %l:%M%P %Z'))
    end

    it 'shows the project name' do
      expect(page).to have_content(assignment.project.name)
    end

    it 'shows the title' do
      expect(page).to have_selector('a', text: assignment.title)
    end

    it 'shows the worker name' do
      expect(page).to have_content(assignment.worker_name)
    end

    it 'shows the location name' do
      expect(page).to have_content(assignment.workmarket_location.name)
    end

    it 'shows the number of attachments' do
      expect(page).to have_selector('td', text: assignment.workmarket_attachments.count.to_s)
    end
  end

  context 'for those with permission to view all data' do
    before do
      client_rep.permissions << create(:permission, key: 'workmarket_assignment_view_all')
      visit client_access_worker_assignments_path
    end

    it 'shows the cost' do
      expect(page).to have_content('$15.00')
    end

    it 'shows the worker email' do
      expect(page).to have_selector('a', text: assignment.worker_email)
    end
  end
end