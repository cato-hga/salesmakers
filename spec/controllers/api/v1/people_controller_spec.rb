require 'rails_helper'

describe API::V1::PeopleController, type: :controller do

  describe 'onboarding' do
    let(:new_emp) { create :person, connect_user_id: '0AA3EE8FCDCF402ABCEB6280D1FC4C8D' }
    let(:creator) { create :person }
    let(:connect_user) { build_stubbed :connect_user }
    subject {
      allow(controller).to receive(:get_creator) { creator }
      allow(controller).to receive(:get_person) { new_emp }
      allow(controller).to receive(:connect_user) { connect_user }
      allow(new_emp).to receive(:import_employment_from_connect) { true }
      get :onboard,
          connect_user_id: '0AA3EE8FCDCF402ABCEB6280D1FC4C8D',
          format: :json
    }

    it 'imports a user when API is called' do
      expect {
        subject
      }.to change(Person, :count).by(2)
    end

    it 'creates a log entry upon import' do
      expect {
        subject
      }.to change(LogEntry, :count).by(1)
    end
  end

  describe 'separating' do
    let!(:separated_user) { create :person,
                                   connect_user_id: 'EEECF92DA2A548FC9FFFC9535DFFEB04',
                                   email: 'jimmy@retaildoneright.com',
                                   devices: [device]
    }
    let(:another_user) { create :person }
    let(:device) { create :device }

    subject {
      allow(controller).to receive(:get_updater) { another_user }
      get :separate,
          connect_user_id: 'EEECF92DA2A548FC9FFFC9535DFFEB04',
          format: :json
    }

    it 'deactivates a user when API is called' do
      expect {
        subject
      }.to change{
        Person.find_by(email: 'jimmy@retaildoneright.com').active?
      }.from(true).to(false)
    end

    it 'creates a log entry upon separation' do
      expect {
        subject
      }.to change(LogEntry, :count).by(1)
    end

    it 'sends emails if the employee has assets' do
      expect { subject }.to change(ActionMailer::Base.deliveries, :count).by(2)
    end
  end
end

