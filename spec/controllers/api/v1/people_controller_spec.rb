require 'rails_helper'

describe API::V1::PeopleController, type: :controller do

  describe 'onboarding' do
    let(:onboard) {
      get :onboard,
          connect_user_id: '337EB300331F4762A4200CDE357E79E6',
          format: :json
      get :onboard,
          connect_user_id: '0AA3EE8FCDCF402ABCEB6280D1FC4C8D',
          format: :json
    }

    it 'imports a user when API is called', :vcr do
      expect {
        onboard
      }.to change(Person.where(email: 'smiles@retaildoneright.com'), :count).by(1)
    end

    it 'creates a log entry upon import', :vcr do
      expect {
        onboard
      }.to change(LogEntry.all, :count).by_at_least(1)
    end
  end

  describe 'separating' do
    let(:onboard) {
      get :onboard,
          connect_user_id: 'EEECF92DA2A548FC9FFFC9535DFFEB04',
          format: :json
    }
    let(:separate) {
      get :separate,
          connect_user_id: 'EEECF92DA2A548FC9FFFC9535DFFEB04',
          format: :json
    }

    it 'deactivates a user when API is called', :vcr do
      onboard
      expect {
        separate
      }.to change{
        Person.find_by(email: 'jimmy@retaildoneright.com').active?
      }.from(true).to(false)
    end

    it 'creates a log entry upon separation',
       :vcr do
      onboard
      expect {
        separate
      }.to change(LogEntry.all, :count).by_at_least(1)
    end
  end

end
