require 'rails_helper'

RSpec.describe API::V1::PeopleController, :type => :controller do

  describe 'onboarding' do
    let(:onboard) {
      visit '/api/v1/people/onboard/337EB300331F4762A4200CDE357E79E6'
      visit '/api/v1/people/onboard/0AA3EE8FCDCF402ABCEB6280D1FC4C8D'
    }

    it 'imports a user when API is called' do
      expect {
        onboard
      }.to change(Person.where(email: 'smiles@retaildoneright.com'), :count).by(1)
    end

    it 'creates a log entry upon import' do
      expect {
        onboard
      }.to change(LogEntry.all, :count).by_at_least(1)
    end
  end

  describe 'separating' do
    before(:each) { visit '/api/v1/people/onboard/EEECF92DA2A548FC9FFFC9535DFFEB04' }
    let(:separate) { visit '/api/v1/people/separate/EEECF92DA2A548FC9FFFC9535DFFEB04' }

    it 'deactivates a user when API is called' do
      expect {
        separate
      }.to change{
        Person.find_by(email: 'jimmy@retaildoneright.com').active?
      }.from(true).to(false)
    end

    it 'creates a log entry upon separation' do
      expect {
        separate
      }.to change(LogEntry.all, :count).by_at_least(1)
    end
  end
end
