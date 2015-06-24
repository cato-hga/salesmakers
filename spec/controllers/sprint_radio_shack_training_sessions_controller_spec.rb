require 'rails_helper'

describe SprintRadioShackTrainingSessionsController do
  let(:person) { create :person }

  before do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
    allow(controller).to receive(:policy).and_return double(new?: true,
                                                            index?: true,
                                                            create?: true,
                                                            edit?: true,
                                                            update?: true)
  end

  describe 'GET index' do
    before { get :index }

    it 'returns a success response' do
      expect(response).to be_success
    end

    it 'renders the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET new' do
    before { get :new }

    it 'returns a success response' do
      expect(response).to be_success
    end

    it 'renders the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let(:training_session) { build :sprint_radio_shack_training_session }
    subject do
      post :create,
           sprint_radio_shack_training_session: {
               name: training_session.name,
               start_date: 'today'
           }
    end

    it 'creates the SprintRadioShackTrainingSession record' do
      expect {
        subject
      }.to change(SprintRadioShackTrainingSession, :count).by(1)
    end

    it 'creates a LogEntry' do
      expect {
        subject
      }.to change(LogEntry, :count).by(1)
    end

    it 'redirects to SprintRadioShackTrainingSessions#index' do
      subject
      expect(response).to redirect_to(sprint_radio_shack_training_sessions_path)
    end
  end

  describe 'GET edit' do
    let!(:training_session) { create :sprint_radio_shack_training_session }

    before { get :edit, id: training_session.id }

    it 'returns a success response' do
      expect(response).to be_success
    end

    it 'renders the edit template' do
      expect(response).to render_template(:edit)
    end
  end

  describe 'PUT update' do
    let!(:training_session) { create :sprint_radio_shack_training_session }

    subject do
      put :update,
          id: training_session.id,
          sprint_radio_shack_training_session: {
              name: 'New Name',
              locked: false,
              start_date: 'today'
          }
    end

    it 'changes the attributes of the training session' do
      subject
      training_session.reload
      expect(training_session.name).to eq('New Name')
    end

    it 'creates a LogEntry' do
      expect {
        subject
      }.to change(LogEntry, :count).by(1)
    end

    it 'redirects to SprintRadioShackTrainingSessions#index' do
      subject
      expect(response).to redirect_to(sprint_radio_shack_training_sessions_path)
    end
  end
end