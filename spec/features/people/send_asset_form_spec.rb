require 'rails_helper'

context 'sending an asset agreement form' do
  let!(:it_tech) { create :it_tech_person, position: position }
  let(:position) { create :it_tech_position, permissions: [permission_update] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:description) { 'TestDescription' }
  let(:permission_update) { Permission.new key: 'device_update', permission_group: permission_group, description: description }
  let(:person) { create :person }

  before do
    CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
    visit person_path(person)
    select 'Mobile Device Agreement Form for Management', from: 'template_guid_and_subject'
  end

  subject { click_on 'Send Form' }

  it 'sends the DocuSign template', :vcr do
    signers = [
        {
            name: person.display_name,
            email: person.email,
            role_name: 'Employee'
        }
    ]
    expect(DocusignTemplate).to receive(:send_ad_hoc_template).with '61B80AC4-0915-45A2-8C4E-DD809C58F953',
                                                                    'Mobile Device Agreement Form for HQ Employee: ' + person.display_name,
                                                                    signers
    subject
  end
end