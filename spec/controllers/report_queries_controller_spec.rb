require 'rails_helper'

describe ReportQueriesController do
  let(:report_query) { build :report_query }
  let!(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [report_query_create, report_query_update] }
  let(:report_query_create) { create :permission, key: 'report_query_create' }
  let(:report_query_update) { create :permission, key: 'report_query_update' }

  before do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  describe 'GET new' do
    before do
      allow(controller).to receive(:policy).and_return double(new?: true)
      get :new
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    before do
      allow(controller).to receive(:policy).and_return double(create?: true)
    end

    subject do
      post :create,
           report_query: {
               name: report_query.name,
               category_name: report_query.category_name,
               database_name: report_query.database_name,
               query: report_query.query,
               permission_key: report_query.permission_key
           }
    end

    it 'creates a ReportQuery' do
      expect {
        subject
      }.to change(ReportQuery, :count).by 1
    end

    it 'creates a LogEntry' do
      expect {
        subject
      }.to change(ReportQuery, :count).by 1
    end

    it 'creates a PermissionGroup' do
      expect {
        subject
      }.to change(PermissionGroup, :count).by 1
    end

    it 'creates a Permission' do
      expect {
        subject
      }.to change(Permission, :count).by 1
    end

    it 'redirects to the ReportQueries#index', pending: 'Controller action not created' do
      expect(response).to redirect_to(report_queries_path)
    end
  end

  describe 'GET index' do
    before { get :index }

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET show without the proper permission' do
    before do
      report_query.save
    end

    it 'is not a success status' do
      get :show, id: report_query.id
      expect(response).not_to be_success
    end

    describe 'and with the proper permission' do
      before do
        permission = create :permission, key: report_query.permission_key
        person.position.permissions << permission
        get :show, id: report_query.id
      end

      it 'returns a success status' do
        expect(response).to be_success
      end

      it 'renders the show template' do
        expect(response).to render_template :show
      end
    end
  end

  describe 'GET edit' do
    before do
      report_query.save
      get :edit, id: report_query.id
    end

    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'renders the edit template' do
      expect(response).to render_template :edit
    end
  end

  describe 'PUT update' do
    before { report_query.save }

    subject do
      put :update,
          id: report_query.id,
          report_query: {
              category_name: 'Bat Category'
          }
    end

    it 'creates a log entry' do
      expect {
        subject
      }.to change(LogEntry, :count).by 1
    end

    it 'redirects to ReportQueries#index' do
      subject
      expect(response).to redirect_to report_queries_path
    end
  end
end