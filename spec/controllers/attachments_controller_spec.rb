require 'rails_helper'

describe AttachmentsController do
  let(:file_upload) { fixture_file_upload 'spec/fixtures/files/image.jpg' }
  let(:person) { create :person }

  before do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'GET new' do
    before { get :new, attachable_id: person.id, attachable_type: person.class.name }

    it 'returns a success response' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST create' do
    subject do
      post :create,
           attachment: {
             name: 'File upload',
             attachable_id: person.id,
             attachable_type: person.class.name,
             attachment: file_upload
           }
    end

    it 'redirects to attachments#new' do
      subject
      expect(response).to redirect_to(person_path(person))
    end

    it 'increases the attachment count' do
      expect {
        subject
      }.to change(Attachment, :count).by 1
    end
  end
end
