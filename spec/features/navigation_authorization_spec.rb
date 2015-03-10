require 'rails_helper'

describe 'Navigation Authorization' do
  let!(:comcast_area) { create :area, project: comcast_project }
  let(:comcast_person_area) { create :person_area, area: comcast_area, person: comcast_employee }
  let(:comcast_project) { create :project, name: 'Comcast Retail' }
  let(:vonage_project) { create :project, name: 'Vonage Retail' }
  let!(:vonage_area) { create :area, project: vonage_project }

  describe 'for top-navigation' do
    describe 'for comcast employees' do
      let(:comcast_employee) { create :person,
                                       position: comcast_position,
                                       email: 'comcastemployee@cc.salesmakersinc.com'
      }
      let(:comcast_permissions) { create :permission, key: 'comcast_customer_create' }
      let(:comcast_position) { create :position, name: 'Comcast Sales Specialist', department: comcast_department }
      let(:comcast_department) { create :department, name: 'Comcast Retail Sales' }

      before(:each) do
        comcast_employee.person_areas << comcast_person_area
        comcast_position.permissions << comcast_permissions
        CASClient::Frameworks::Rails::Filter.fake(comcast_employee.email)
        visit root_path
      end
      it 'contains links to the sales page' do
        within('.top-bar') do
          expect(page).to have_content('New Customer')
        end
      end
      it 'does not contain links to other sales pages' do
        within('.top-bar') do
          expect(page).not_to have_content('Vonage')
        end
      end
      it 'does not contain links to the Admin or People section' do
        within('.top-bar') do
          expect(page).not_to have_content('Admin')
          expect(page).not_to have_content('People')
        end
      end
      it 'contains a link to existing customers' do
        within('.top-bar') do
          expect(page).to have_content('My Customers')
        end
      end
      it 'contains a link to the EOD page' do
        within('.top-bar') do
          expect(page).to have_content('End Of Day')
        end
      end
    end

    describe 'for administrators' do
      let(:it_employee) { create :person, position: position, email: 'ittech@salesmakersinc.com' }
      let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
      let(:device_index_permission) { create :permission, key: 'device_index' }
      let(:changelog_entry_manage_permission) { create :permission, key: 'changelog_entry_manage' }
      let(:log_entry_index_permission) { create :permission, key: 'log_entry_index' }
      let(:candidate_index_permission) { Permission.new key: 'candidate_index',
                                                        permission_group: permission_group,
                                                        description: 'Test Description' }
      let(:person_create_permission) { Permission.new key: 'person_create',
                                                      permission_group: permission_group,
                                                      description: 'Test Description' }
      let(:person_index_permission) { Permission.new key: 'person_index',
                                                     permission_group: permission_group,
                                                     description: 'Test Description' }
      let(:position) { create :position, name: 'IT Tech',
                              department: department,
                              hq: true,
                              permissions: [device_index_permission,
                                            changelog_entry_manage_permission,
                                            log_entry_index_permission,
                                            candidate_index_permission,
                                            person_create_permission,
                                            person_index_permission] }
      let(:department) { create :department, name: 'Information Technology' }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(it_employee.email)
        visit root_path
      end


      it 'does contain links to candidates' do
        within('.top-bar') do
          expect(page).to have_content('Candidates')
        end
      end
      it 'does contain links to the Admin section' do
        within('.top-bar') do
          expect(page).to have_content('Admin')
          expect(page).to have_content('Device Models')
          expect(page).to have_content('Devices')
          expect(page).to have_content('Lines')
          expect(page).to have_content('Changelog')
          expect(page).to have_content('Log')
        end
      end
      it 'contains links to the sales page for all projects' do
        within('.top-bar') do
          expect(page).to have_content('Comcast')
          expect(page).to have_content('Vonage')
        end
      end
      it 'contains links to Areas' do
        within('.top-bar') do
          expect(page).to have_content('Areas')
        end
      end
      it 'contains a link to create a new person' do
        expect(page).to have_selector('a[href="/people/new"]')
      end
    end

    describe 'for recruiters' do
      let(:recruiter) { create :person, position: position }
      let(:position) { create :position, name: 'Advocate', department: department, permissions: [permission_create, permission_index] }
      let(:department) { create :department, name: 'Advocate Department' }
      let(:permission_group) { PermissionGroup.create name: 'Test Permission Group' }
      let!(:permission_index) { Permission.create key: 'candidate_index',
                                              permission_group: permission_group,
                                              description: 'Test Description' }
      let!(:permission_create) { Permission.create key: 'candidate_create',
                                               permission_group: permission_group,
                                               description: 'Test Description' }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
        visit root_path
      end

      it 'contains links to candidates' do
        within('.top-bar') do
          expect(page).to have_content('Candidates')
        end
      end

      it 'does not contain links to the Admin section' do
        within('.top-bar') do
          expect(page).not_to have_content('Admin')
        end
      end
    end
  end

  describe 'for off-canvas navigation', js: true do
    describe 'for comcast employees' do
      let(:comcast_employee) { create :person,
                                       position: comcast_position,
                                       email: 'comcastemployee@cc.salesmakersinc.com'
      }
      let(:comcast_permissions) { create :permission, key: 'comcast_customer_create' }
      let(:comcast_position) { create :position, name: 'Comcast Sales Specialist', department: comcast_department }
      let(:comcast_department) { create :department, name: 'Comcast Retail Sales' }

      before(:each) do
        comcast_employee.person_areas << comcast_person_area
        comcast_position.permissions << comcast_permissions
        CASClient::Frameworks::Rails::Filter.fake(comcast_employee.email)
        page.driver.resize_window 640, 480
        visit root_path
      end
      it 'contains links to the sales page' do
        within('.left-off-canvas-menu') do
          expect(page).to have_content('COMCAST')
          #Not yet below
          #expect(page).to have_content('Sales')
        end
      end
      it 'does not contain links to other sales pages' do
        within('.left-off-canvas-menu') do
          expect(page).not_to have_content('Vonage')
        end
      end
      it 'does not contain links to the Admin section' do
        within('.left-off-canvas-menu') do
          expect(page).not_to have_content('Administration')
        end
      end
      it 'contains a link to existing customers' do
        within('.left-off-canvas-menu') do
          expect(page).to have_content('My Customers')
        end
      end
      it 'contains a link to the EOD page' do
        within('.left-off-canvas-menu') do
          expect(page).to have_content('End Of Day')
        end
      end
    end

    describe 'for recruiters' do
      let(:recruiter) { create :person, position: position }
      let(:position) { create :position, name: 'Advocate', department: department, permissions: [permission_create, permission_index] }
      let(:department) { create :department, name: 'Advocate Department' }
      let(:permission_group) { PermissionGroup.create name: 'Test Permission Group' }
      let!(:permission_index) { Permission.create key: 'candidate_index',
                                              permission_group: permission_group,
                                              description: 'Test Description' }
      let!(:permission_create) { Permission.create key: 'candidate_create',
                                               permission_group: permission_group,
                                               description: 'Test Description' }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
        page.driver.resize_window 640, 480
        visit root_path
      end

      it 'contains links to candidates' do
        within('.left-off-canvas-menu') do
          expect(page).to have_content('Candidates List')
        end
      end

      it 'contains a link to a new candidate' do
        within('.left-off-canvas-menu') do
          expect(page).to have_content('New Candidate')
        end
      end

      it 'does not contain links to the Admin section' do
        within('.left-off-canvas-menu') do
          expect(page).not_to have_content('People')
        end
      end
    end

    describe 'for administrators' do
      let(:it_employee) { create :person, position: position, email: 'ittech@salesmakersinc.com' }
      let(:permissions) { create :permission, key: 'device_index' }
      let(:position) {
        create :position,
               name: 'IT Tech',
               department: department,
               hq: true,
               permissions: [
                   permissions, person_create_permission, person_index_permission
               ]
      }
      let(:department) { create :department, name: 'Information Technology' }
      let(:person_create_permission) { Permission.new key: 'person_create',
                                                      permission_group: permissions.permission_group,
                                                      description: 'Test Description' }
      let(:person_index_permission) { Permission.new key: 'person_index',
                                                     permission_group: permissions.permission_group,
                                                     description: 'Test Description' }

      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(it_employee.email)
        page.driver.resize_window 640, 480
        visit root_path
      end
      it 'does contain links to the Admin section' do
        within('.left-off-canvas-menu') do
          expect(page).to have_content('ADMINISTRATION')
          expect(page).to have_content('Device Models')
          expect(page).to have_content('Devices')
          expect(page).to have_content('Lines')
        end
      end
      it 'contains links to the sales page for all projects' do
        within('.left-off-canvas-menu') do
          expect(page).to have_content('COMCAST RETAIL')
          expect(page).to have_content('VONAGE RETAIL')
        end
      end
      it 'contains links to Areas' do
        within('.left-off-canvas-menu') do
          expect(page).to have_content('Areas')
        end
      end
      it 'contains a link to create a new person' do
        within('.left-off-canvas-menu') do
          expect(page).to have_selector('a[href="/people/new"]')
        end
      end
    end
  end
end