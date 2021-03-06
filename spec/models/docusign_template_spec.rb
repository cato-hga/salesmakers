# == Schema Information
#
# Table name: docusign_templates
#
#  id            :integer          not null, primary key
#  template_guid :string           not null
#  state         :string(2)        not null
#  document_type :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  project_id    :integer          not null
#

require 'rails_helper'

describe DocusignTemplate do
  subject { build :docusign_template }

  it 'requires the state be valid' do
    subject.state = 'NB'
    expect(subject).not_to be_valid
  end

  describe 'Docusign sending, NHP' do
    let!(:docusign_template) {
      create :docusign_template,
             template_guid: '603E81AB-4DC0-4FBC-9028-46D1FCABDD21',
             state: 'FL',
             project: location_area.area.project,
             document_type: 0
    }
    let(:candidate) {
      create :candidate,
             state: 'FL',
             email: 'developers@salesmakersinc.com',
             location_area: location_area
    }
    let(:location_area) { create :location_area }
    let(:person) { create :person, email: 'developers@salesmakersinc.com' }

    it 'sends an NHP', :vcr do
      envelope_response = DocusignTemplate.send_nhp candidate, person
      expect(envelope_response.length).to be > 0
    end
  end

  describe 'Docusign sending, NOS' do
    let!(:docusign_template) {
      create :docusign_template,
             template_guid: 'CD15C02E-B073-44D9-A60A-6514C24949CB',
             project: person_area.area.project,
             document_type: 2
    }
    let!(:manager) { create :person,
                            display_name: 'Test Manager',
                            email: 'smiles@retaildoneright.com'
    }
    let!(:regional) { create :person, display_name: 'Test Regional', email: 'developers@salesmakersinc.com' }
    let(:person) { create :person }

    let!(:person_area) { create :person_area, person: person, area: area }
    let(:area) { create :area, project: project }
    let(:project) { create :project }
    let(:reason) { create :employment_end_reason, name: 'M103 Sleeping on the Job', active: true }
    let(:remark) { 'This is a test remark that will go over a string length and into a text area length' }

    it 'sends an NOS', :vcr do
      envelope_response = DocusignTemplate.send_nos(person, regional, DateTime.now, DateTime.now, reason, false, false, remark)
      expect(envelope_response.length).to be > 0
    end
  end

  describe 'Docusign Sending, Third Party NOS' do
    describe 'Docusign sending, NOS' do
      let!(:docusign_template) {
        create :docusign_template,
               template_guid: 'E0D92C92-D229-4C25-9CAF-E258FA990AF5',
               project: person_area.area.project,
               document_type: 2
      }
      let!(:manager) { create :person,
                              display_name: 'Test Manager',
                              email: 'smiles@retaildoneright.com'
      }
      let(:person) { create :person }
      let!(:person_area) { create :person_area, person: person, area: area }
      let(:area) { create :area, project: project }
      let(:project) { create :project }

      it 'sends an NOS', :vcr do
        envelope_response = DocusignTemplate.send_third_party_nos(person, manager)
        expect(envelope_response.length).to be >0
      end
    end
  end

  describe 'Docusign Sending, simple template ID with signers' do
    let!(:template_guid) { 'E0D92C92-D229-4C25-9CAF-E258FA990AF5' }
    let!(:manager) { create :person,
                            display_name: 'Test Manager',
                            email: 'smiles@retaildoneright.com'
    }

    it 'sends an NOS', :vcr do
      signers = [
          {
              name: manager.display_name,
              email: manager.email,
              role_name: 'Manager'
          }
      ]
      envelope_response = DocusignTemplate.send_ad_hoc_template template_guid, 'This is a subject', signers
      expect(envelope_response.length).to be > 0
    end
  end
end
