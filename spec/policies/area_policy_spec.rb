
describe AreaPolicy do


  #TODO: Start a rewrite here. http://stackoverflow.com/questions/20557022/factories-with-ancestry-for-testing
  #Basically, we need to rewrite the areas in order to give them child factories

  let(:client) { build_stubbed :client }
  let(:project) { build_stubbed :project, client: client }
  let(:territory) { build_stubbed :area_type, name: 'Test Territory', project: project }

  #Positions
  let(:sales_specialist) { build_stubbed :position }
  let(:territory_manager) {
    build_stubbed :position,
           name: 'Vonage Area Sales Manager',
           leadership: true
  }
  let(:software_developer) {
    build_stubbed :position,
           name: 'Software Development',
           hq: true
  }

  #Areas
  let(:orlando_area) { create :area, name: 'Orlando Retail Territory', area_type: territory, project: project}
  let(:tampa_area) { create :area, name: 'Tampa Retail Territory', area_type: territory, project: project }

  #People
  let(:tampa_person) {
    person = build_stubbed :person, position: sales_specialist
    person_area = create :person_area, area: tampa_area, person: person
    person
  }

  let(:hq_employee) { build_stubbed :person, position: software_developer }

  describe 'visibility' do
    let(:hq_employee_policy_scope) { Pundit.policy_scope(hq_employee, Area.all) }

    it 'should include nothing if a person isnt passed' do
      expect(Pundit.policy_scope(person = nil, Area.all).all).not_to include(orlando_area)
    end

    it 'should include all areas if a person is from HQ' do
      expect(Pundit.policy_scope(hq_employee, Area.all).all).to include(orlando_area) and (tampa_area)
    end
    #
    # it 'should include all sub-areas that a person manages' do
    #   expect(Pundit.policy_scope(market_manager, Area.all).all).to include(florida_market.children)#(orlando_area) and (@tampa) and
    # end

    it 'should include a persons person_area' do #TODO: Ok so this test technically works, but it needs to be looked at
      expect(Pundit.policy_scope(tampa_person, Area.all).all).to include(tampa_area)
    end
  end
end