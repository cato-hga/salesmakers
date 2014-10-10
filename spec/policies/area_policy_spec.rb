require 'rails_helper'

describe AreaPolicy do


  #TODO: Start a rewrite here. http://stackoverflow.com/questions/20557022/factories-with-ancestry-for-testing
  #Basically, we need to rewrite the areas in order to give them child factories

  #Positions
  let(:sales_specialist) { create :position }
  let(:territory_manager) {
    create :position,
           name: 'Vonage Retail Area Sales Manager',
           leadership: true
  }
  let(:market_manager_position) {
    create :position,
           name: 'Vonage Retail Area Sales Manager',
           leadership: true
  }
  let(:software_developer) {
    create :position,
           name: 'Software Development',
           hq: true
  }

  #Area Types
  let(:vonage_retail_market) { create :vonage_retail_market }

  #Areas
  let(:orlando_area) { create :area, name: 'Orlando Retail Territory'}
  let(:florida_market) { create :area, name: 'Florida Retail Market', area_type: vonage_retail_market }

  #People
  let!(:tampa_person) {
    @tampa = create :area, name: 'Tampa Retail Territory'
    person = create :person, position: sales_specialist
    person_area = create :person_area, area: @tampa, person: person
    person
  }
  let(:area_manager) {
    person = create :person,
                    position: territory_manager
    person_area = create :person_area, area: @tampa, person: person, manages: true
    person
  }
  let(:market_manager) {
    person = create :person,
                    position: market_manager_position
    person_area = create :person_area, area: florida_market, person: person#, manage: true
    person
  }
  let(:hq_employee) { create :person, position: software_developer }

  describe 'visibility' do
    it 'should include nothing if a person isnt passed' do
      expect(Pundit.policy_scope(person = nil, Area.all).all).not_to include(orlando_area)
    end

    it 'should include all areas if a person is from HQ' do
      expect(Pundit.policy_scope(hq_employee, Area.all).all).to include(orlando_area) and (@tampa)
    end

    it 'should include all sub-areas that a person manages' do
      expect(Pundit.policy_scope(market_manager, Area.all).all).to include(florida_market.children)#(orlando_area) and (@tampa) and
    end

    it 'should include a persons person_area' do #TODO: Ok so this test technically works, but it needs to be looked at
      expect(Pundit.policy_scope(tampa_person, Area.all).all).to include(@tampa)
    end
  end
end