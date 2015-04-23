# require 'rails_helper'
# require 'support/solr'
#
# describe 'global, full text searching' do
#   include SolrSpecHelper
#
#   let!(:candidate) { create :candidate, first_name: 'Robert', last_name: 'Johnson' }
#   let!(:person) { create :person, display_name: 'Robert Kennedy' }
#   let!(:device) { create :device, serial: 'Robert', identifier: '123456789' }
#
#   before :all do
#     solr_setup
#   end
#
#   after :all do
#     Candidate.remove_all_from_index!
#     Person.remove_all_from_index!
#     Device.remove_all_from_index!
#     Line.remove_all_from_index!
#   end
#
#   after :all do
#     `bundle exec rake sunspot:solr:stop RAILS_ENV=test`
#   end
#
#   context 'for those with all permissions' do
#     let!(:it_tech) { create :it_tech_person, position: position }
#     let(:position) { create :it_tech_position, permissions: [device_index, candidate_index], hq: true }
#     let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
#     let(:description) { 'TestDescription' }
#     let(:device_index) { Permission.new key: 'device_index', permission_group: permission_group, description: description }
#     let(:candidate_index) { Permission.new key: 'candidate_index', permission_group: permission_group, description: description }
#     before(:each) do
#       CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
#     end
#
#     it 'shows all objects', skip_solr_mocking: true do
#       visit root_path
#       fill_in 'global_search', with: 'robert'
#       click_on 'global_search_submit'
#       expect(page).to have_content('Johnson')
#       expect(page).to have_content('Kennedy')
#       expect(page).to have_content('123456789')
#     end
#   end
#
#   context 'for those without a particular permission' do
#     let!(:recruiter) { create :person, position: position }
#     let(:department) { create :department, name: 'Advocate Department' }
#     let(:position) { create :position, permissions: [candidate_index], department: department }
#     let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
#     let(:description) { 'TestDescription' }
#     let(:candidate_index) { Permission.new key: 'candidate_index', permission_group: permission_group, description: description }
#     before(:each) do
#       CASClient::Frameworks::Rails::Filter.fake(recruiter.email)
#     end
#
#     it 'shows all relevant objects', skip_solr_mocking: true do
#       visit root_path
#       fill_in 'global_search', with: 'robert'
#       click_on 'global_search_submit'
#       expect(page).to have_content('Johnson')
#       expect(page).to have_content('Kennedy')
#       expect(page).not_to have_content('123456789')
#     end
#   end
# end