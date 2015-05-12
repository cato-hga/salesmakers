require 'rails_helper'

describe DocusignTemplate do
  subject { build :docusign_template }

  it 'is correct with valid attributes' do
    expect(subject).to be_valid
  end

  it 'requires a template_guid' do
    subject.template_guid = nil
    expect(subject).not_to be_nil
  end

  it 'requires a state' do
    subject.state = nil
    expect(subject).not_to be_valid
  end

  it 'requires the state be valid' do
    subject.state = 'NB'
    expect(subject).not_to be_valid
  end

  it 'requires a document_type' do
    subject.document_type = nil
    expect(subject).not_to be_valid
  end

  it 'requires a project' do
    subject.project = nil
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
end
