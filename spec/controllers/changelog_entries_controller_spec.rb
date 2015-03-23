require 'rails_helper'

describe ChangelogEntriesController do
  let(:person) { create :it_tech_person }
  let(:permission_manage) { create :permission, key: 'changelog_entry_manage' }

  before do
    Time.zone = ActiveSupport::TimeZone["Eastern Time (US & Canada)"]
    person.position.permissions << permission_manage
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'GET index' do
    before { get :index }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET new' do
    before { get :new }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:entry) { build :changelog_entry }


    subject do
      post :create,
           changelog_entry: entry.attributes
    end

    it 'redirects to index' do
      subject
      expect(response).to redirect_to(changelog_entries_path)
    end

    it 'increases the ChangelogEntry count' do
      expect {
        subject
      }.to change(ChangelogEntry, :count).by(1)
    end
  end
end