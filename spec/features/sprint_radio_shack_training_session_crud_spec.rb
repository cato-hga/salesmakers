require 'rails_helper'

describe 'CRUD for SprintRadioShackTrainingSessions' do
  let(:person) { create :person, position: position }
  let(:position) { create :position, permissions: [permission_create, permission_index, permission_update] }
  let(:permission_group) { PermissionGroup.new name: 'Test Permission Group' }
  let(:permission_create) { Permission.create key: 'sprint_radio_shack_training_session_create',
                                              permission_group: permission_group,
                                              description: 'Test Description' }
  let(:permission_index) { Permission.create key: 'sprint_radio_shack_training_session_index',
                                             description: 'Blah blah blah',
                                             permission_group: permission_group }
  let(:permission_update) { Permission.create key: 'sprint_radio_shack_training_session_update',
                                             description: 'Blah blah blah',
                                             permission_group: permission_group }

  describe 'creating a new session' do
    let(:training_session) { build :sprint_radio_shack_training_session, name: 'Foobartrainingsession' }

    before do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit sprint_radio_shack_training_sessions_path
      click_on 'new_action_button'
      fill_in 'Name', with: training_session.name
      fill_in 'Start date', with: 'today'
    end

    subject { click_on 'Save' }

    it 'creates the SprintRadioShackTrainingSession record' do
      expect {
        subject
      }.to change(SprintRadioShackTrainingSession, :count).by(1)
    end

    it 'creates a log entry' do
      expect {
        subject
      }.to change(LogEntry, :count).by(1)
    end
  end

  describe 'editing an existing session' do
    let!(:training_session) { create :sprint_radio_shack_training_session, name: 'Foobartrainingsession' }

    before do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit sprint_radio_shack_training_sessions_path
      click_on training_session.name
      fill_in 'Name', with: 'Foobarbat Session'
    end

    subject { click_on 'Save' }

    it 'changes the session' do
      subject
      training_session.reload
      expect(training_session.name).to eq('Foobarbat Session')
    end

    it 'creates a log entry' do
      expect {
        subject
      }.to change(LogEntry, :count).by(1)
    end
  end

end