require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Area, :type => :model do

  it { should ensure_length_of(:name).is_at_least(3) }
  it { should validate_presence_of(:area_type) }

  it { should belong_to(:area_type) }
  it { should belong_to(:project) }
  it { should have_many(:person_areas) }
  it { should have_many(:people).through(:person_areas) }
  #it { should have_one(:wall) }

  # Scope isn't currently used. Test will pass once uncommented
  # describe 'member_of scope' do
  #   let(:hq_person) { Person.first }
  #   let(:non_hq_area) { create :area }
  #   let(:non_hq_person) { create :person }
  #   let!(:non_hq_person_area) { create :person_area, area: non_hq_area, person: non_hq_person}
  #
  #   context 'for HQ employees' do
  #     it 'should return all areas a person is a member of' do
  #       expect(Area.member_of(hq_person)).not_to be_nil
  #     end
  #   end
  #
  #   context 'for non-hq employees' do
  #     it 'should return all areas a person is a member of' do
  #       expect(Area.member_of(non_hq_person)).not_to be_nil
  #     end
  #   end
  # end

  #TODO: Refactor the following two specs to use the RSPEC LET method
  it ' project_roots scope should return project_roots' do
    proj = Project.first
    expect(Area.project_roots(proj)).not_to be_nil
  end

  it 'managers method should return all areas that a person manages' do
    person = create :person
    area = create :area
    p_a = create(:person_area, person: person, area: area, manages: true)
    expect(area.managers).not_to be_nil
  end

  describe 'non_managers method' do
    let(:area) { create :area }
    let(:inactive_person) { create :person, active: false }
    let(:active_person) { create :person }
    let!(:person_area) { create :person_area, person: active_person, area: area }
    let!(:inactive_person_area) { create :person_area, person: inactive_person, area: area}

    context 'for only active employees' do
      it 'should return all active, non-managers of a given area' do
        non_managers_count = area.non_managers.where(active: true).count
        expect(non_managers_count).to eq(1)
      end
    end

    context 'for inactive and active employees' do
      it 'should return all non-managers of a given area' do
        non_managers_count = area.non_managers.count
        expect(non_managers_count).to eq(2)
      end
    end
  end

  describe 'locations' do
    let(:area_one) { create :area }
    let(:area_two) { create :area, name: 'Area Two' }
    let(:location_one) { create :location }
    let(:location_two) { create :location }
    let!(:location_area_one) {
      create :location_area,
             location: location_one,
             area: area_one
    }
    let!(:location_area_two) {
      create :location_area,
             location: location_two,
             area: area_two
    }

    before do
      area_two.update parent: area_one
    end

    it 'returns only the locations in the area with #locations' do
      expect(area_one.locations.count).to eq(1)
    end

    it 'returns all locations in the tree for #all_locations' do
      expect(area_one.all_locations.count).to eq(2)
    end
  end
end
