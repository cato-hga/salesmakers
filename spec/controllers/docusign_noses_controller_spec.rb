require 'rails_helper'

describe DocusignNosesController do

  let(:manager) { create :person, display_name: 'Manager' }
  let(:person) { create :person }
  let!(:person_area) { create :person_area, area: area, person: person }
  let(:area) { create :area, project: project }
  let(:project) { create :project, name: 'Sprint Postpaid' }
  let!(:template) { create :docusign_template,
                           template_guid: 'CD15C02E-B073-44D9-A60A-6514C24949CB',
                           state: 'FL',
                           document_type: 2,
                           project: project }
  describe 'GET new' do
    it 'returns a success status' do
      allow(controller).to receive(:policy).and_return double(terminate?: true)
      get :new, person_id: person.id
      expect(response).to be_success
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let!(:reason) { EmploymentEndReason.create name: 'Test Reason', active: true }
    before {
      CASClient::Frameworks::Rails::Filter.fake(manager.email)
      allow(controller).to receive(:policy).and_return double(terminate?: true)
    }

    context 'success' do
      subject {
        post :create,
             person_id: person.id,
             docusign_nos: {
                 eligible_to_rehire: false,
                 termination_date: Date.today.to_s,
                 last_day_worked: Date.yesterday.to_s,
                 employment_end_reason_id: reason.id,
                 remarks: 'Test remarks'
             }
      }
      it 'creates a DocusignNOS object', :vcr do
        expect { subject }.to change(DocusignNos, :count).by(1)
      end
      it 'sends an NOS', :vcr do
        expect(DocusignTemplate).to receive(:send_nos)
        subject
      end
      it 'attaches the correct attributes', :vcr do
        subject
        nos = DocusignNos.first
        expect(nos.person).to eq(person)
        expect(nos.envelope_guid).not_to be_nil
      end
      it 'does not deactivate the person', :vcr do
        subject
        person.reload
        expect(person.active).to eq(true)
      end
      it 'redirects to the the person index', :vcr do
        subject
        expect(response).to redirect_to people_path
      end
    end

    context 'failure' do
      subject {
        allow_any_instance_of(DocusignTemplate).to receive(:send_nos).and_return(nil)
        allow_any_instance_of(DocusignNos).to receive(:save).and_return(false)
        post :create,
             person_id: person.id,
             docusign_nos: {
                 eligible_to_rehire: '',
                 termination_date: Date.today.to_s,
                 last_day_worked: Date.yesterday.to_s,
                 employment_end_reason_id: reason.id,
                 remarks: 'Test remarks'
             }
      }
      it 'does not create a DocusignNOS object', :vcr do
        expect { subject }.not_to change(DocusignNos, :count)
      end
      it 'does not deactivate the person', :vcr do
        subject
        person.reload
        expect(person.active).to eq(true)
      end
      it 'renders the new template', :vcr do
        subject
        expect(response).to render_template(:new)
      end
    end
  end
end
