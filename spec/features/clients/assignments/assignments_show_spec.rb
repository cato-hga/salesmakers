require 'rails_helper'

describe 'assignments index' do
  let!(:client_rep) { create :client_representative, permissions: [permission] }
  let!(:project) { create :project, client: client_rep.client }
  let!(:permission) { create :permission, key: 'workmarket_assignment_show' }
  let!(:assignment) { create :workmarket_assignment, project: project }
  let!(:attachment) { create :workmarket_attachment, workmarket_assignment: assignment }
  let!(:field) { create :workmarket_field, workmarket_assignment: assignment }
  let!(:location) { create :workmarket_location, workmarket_location_num: assignment.workmarket_location_num }

  before do
    page.set_rack_session client_representative_id: client_rep.id
  end

  context 'for those without permission to see SalesMakers-specific data' do
    before do
      visit client_access_worker_assignment_path(assignment)
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
      expect(page).to have_selector('h1', text: assignment.title)
    end

    it 'shows the worker name' do
      expect(page).to have_content(assignment.worker_name)
    end

    it 'shows the location name' do
      expect(page).to have_content(assignment.workmarket_location.name)
    end

    it 'shows the location number' do
      expect(page).to have_content(assignment.workmarket_location.location_number)
    end

    it 'shows the fields' do
      expect(page).to have_content(field.name)
      expect(page).to have_content(field.value)
    end

    it 'shows the attachments' do
      expect(page).to have_selector("img[src='https://www.workmarket.com#{attachment.url}']")
    end

    it 'shows the attachment filenames' do
      expect(page).to have_content(attachment.filename)
    end
  end

  context 'for those with permission to view all data' do
    before do
      client_rep.permissions << create(:permission, key: 'workmarket_assignment_view_all')
      visit client_access_worker_assignment_path(assignment)
    end

    it 'shows the cost' do
      expect(page).to have_content('$15.00')
    end

    it 'shows the worker email' do
      expect(page).to have_selector('a', text: assignment.worker_email)
    end
  end
end