require 'rails_helper'

RSpec.describe API::V1::PeopleController, :type => :controller do

  describe 'onboarding and separating' do

    it 'imports a user when API is called' do
      expect {
        visit '/api/v1/people/onboard/EEECF92DA2A548FC9FFFC9535DFFEB04'
      }.to change(Person.where(email: 'jimmy@retaildoneright.com'), :count).by(1)
    end

    it 'deactivates a user when API is called' do
      visit '/api/v1/people/onboard/EEECF92DA2A548FC9FFFC9535DFFEB04'
      expect {
        visit '/api/v1/people/separate/EEECF92DA2A548FC9FFFC9535DFFEB04'
      }.to change{
        Person.find_by(email: 'jimmy@retaildoneright.com').active?
      }.from(true).to(false)
    end

  end
end
