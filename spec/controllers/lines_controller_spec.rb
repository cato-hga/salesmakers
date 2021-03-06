require 'rails_helper'

describe LinesController do

  describe 'GET index' do
    before {
      allow(controller).to receive(:policy).and_return double(index?: true)
      get :index }
    it 'should return a success status' do
      expect(response).to be_success
    end
    it 'should render the index template' do
      expect(response).to render_template(:index)
    end
  end

  describe 'GET new' do
    before {
      allow(controller).to receive(:policy).and_return double(new?: true)
      get :new }
    it 'should return a success status' do
      expect(response).to be_success
    end
    it 'should render the new template' do
      expect(response).to render_template(:new)
    end
  end

  describe 'POST create' do
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      allow(controller).to receive(:policy).and_return double(create?: true)
    end
    context 'success (valid data)' do
      subject {
        post :create,
             line: {
                 technology_service_provider_id: service_provider.id,
                 identifier: line_identifier,
                 contract_end_date: contract_end_date
             }
      }
      let!(:service_provider) { create :technology_service_provider }
      let(:line_identifier) { '5555555555' }
      let(:contract_end_date) { Date.today + 1.year }
      let!(:line_state) { create :line_state, name: 'Active' }
      it 'creates a line' do
        expect { subject }.to change(Line, :count).by(1)
      end
      it 'creates log entries' do
        expect { subject }.to change(LogEntry, :count).by(1)
      end
      it 'should redirect to lines#index' do
        expect(subject).to redirect_to(lines_path)
      end
    end

    context 'failure' do
      let!(:service_provider) { create :technology_service_provider }
      let(:invalid_line_identifier) { '5555555555' }
      let(:contract_end_date) { Date.today + 1.year }
      let!(:line_state) { create :line_state, name: 'Active' }
      context 'invalid data' do
        subject {
          post :create,
               line: {
                   contract_end_date: contract_end_date.strftime('%m/%d/%Y'),
                   technology_service_provider_id: service_provider.id,
                   line_identifier: invalid_line_identifier
               }
        }
        it 'presents an error when form is invalid' do
          subject
          expect(flash[:error]).to be_present
        end
        it 'should render the new template' do
          expect(subject).to redirect_to(new_line_path)
        end
      end
    end
  end

  describe 'PATCH update' do
    let!(:old_line) { create :line }
    let(:new_line) { create :line, identifier: '5555555555' }
    let!(:device) { create :device, line: old_line }
    let!(:person) { create :it_tech_person, position: position }
    let(:position) { create :it_tech_position }
    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      allow(controller).to receive(:policy).and_return double(update?: true)
    end
    subject {
      patch :update,
            id: old_line.id,
            serial: [device.serial],
            line: [new_line.identifier]
    }
    it 'takes the swap params and updates' do
      subject
      device.reload
      expect(device.line).to eq(new_line)
      expect(device.line).not_to eq(old_line)
    end

    it 'creates log entries' do
      expect { subject }.to change(LogEntry, :count).by(1)
    end

    it 'redirects to the lines index page' do
      subject
      expect(response).to redirect_to(lines_path)
    end
  end

  describe 'states' do
    let(:line) { create :line }
    let(:locked_state) { create :line_state, locked: true }
    let(:unlocked_state) { create :line_state, locked: false }

    describe 'PATCH remove_state' do
      let!(:person) { create :it_tech_person, position: position }
      let(:position) { create :it_tech_position }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        allow(controller).to receive(:policy).and_return double(remove_state?: true)
      end
      context 'with an unlocked state' do
        subject {
          patch :remove_state,
                id: line.id,
                line_state_id: unlocked_state.id
        }

        it 'removes the line state' do
          line.line_states << unlocked_state
          expect { subject }.to change(line.line_states, :count).by(-1)
        end

        it 'logs the removal of the line state' do
          expect { subject }.to change(LogEntry, :count).by(1)
        end
      end

      context 'with a locked state' do
        it 'allows the removal of the line state' do
          line.line_states << locked_state
          expect {
            patch :remove_state,
                  id: line.id,
                  line_state_id: locked_state.id
          }.not_to change(line.line_states, :count)
        end
      end
    end

    describe 'PATCH add_state' do
      let!(:person) { create :it_tech_person, position: position }
      let(:position) { create :it_tech_position }
      before(:each) do
        CASClient::Frameworks::Rails::Filter.fake(person.email)
        allow(controller).to receive(:policy).and_return double(add_state?: true)
      end
      context 'with an unlocked state' do
        subject {
          patch :add_state,
                id: line.id,
                line_state_id: unlocked_state.id
        }

        it 'allows an unlocked state to be added' do
          expect { subject }.to change(line.line_states, :count).by(1)
        end

        it 'logs the removal of the line state' do
          expect { subject }.to change(LogEntry, :count).by(1)
        end
      end

      it 'does not allow a locked state to be added' do
        expect {
          patch :add_state,
                id: line.id,
                line_state_id: locked_state.id
        }.not_to change(line.line_states, :count)
      end
    end
  end

  describe 'deactivation' do
    before(:each) do
      allow(controller).to receive(:policy).and_return double(deactivate?: true)
    end
    let(:device) { create :device, line: line }
    let(:active_state) { create :line_state, name: 'Active', locked: true }
    let(:line) do
      new_line = create :line
      new_line.line_states << active_state
      new_line
    end

    subject {
      patch :deactivate,
            id: line.id
      line.reload
    }

    it 'deactivates a line' do
      expect { subject }.to change(line, :active?).from(true).to(false)
    end

    it 'detaches from a device' do
      expect {
        subject
        device.reload
      }.to change(device, :line).from(line).to(nil)
    end
  end
end
