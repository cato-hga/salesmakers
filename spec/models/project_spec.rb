require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Project, :type => :model do

  it { should ensure_length_of(:name).is_at_least(4) }
  it { should validate_presence_of(:client) }

  it { should belong_to :client }
  it { should have_many :area_types }
  it { should have_many :areas }

  describe 'active_people method' do
    let(:area) { create :area }
    let(:project) { area.project }
    let(:person) { create :person }
    let!(:person_area) { create :person_area, area: area, person: person }

    it 'should return active people for a project' do
      expect((project.active_people).count).to eq(1)
    end
  end

  describe 'locations' do
    let(:area_one) { create :area }
    let(:area_two) {
      create :area,
             name: 'Area Two',
             project: area_one.project
    }
    let(:area_three) {
      create :area,
             name: 'Area Three',
             project: create(:project, name: 'Project Two')
    }
    let(:location_one) { create :location }
    let(:location_two) { create :location }
    let(:location_three) { create :location }
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
    let!(:location_area_three) {
      create :location_area,
             location: location_three,
             area: area_three
    }
    let(:project_one) { area_one.project }
    let(:project_two) { area_three.project }

    before do
      area_two.update parent: area_one
    end

    it 'returns the correct number of locations for a project' do
      expect(project_one.locations.count).to eq(2)
      expect(project_two.locations.count).to eq(1)
    end
  end

  describe 'visible scope' do
    let(:hq_position) { create :position, hq: true }
    let(:not_hq_position) { create :position, hq: false }
    let(:foo_project) { create :project, name: 'Foo Project' }
    let(:foo_area) { create :area, project: foo_project }
    let!(:bar_project) { create :project, name: 'Bar Project' }
    let(:foo_rep) {
      create :person,
             position: not_hq_position
    }
    let!(:foo_rep_person_area) {
      create :person_area,
             person: foo_rep,
             area: foo_area
    }
    let(:hq_employee) {
      create :person,
             position: hq_position
    }

    it 'returns an empty set with no person argument' do
      expect(Project.visible).to be_empty
    end

    context 'as a rep' do
      let(:visible) { Project.visible(foo_rep) }

      it 'has the proper count' do
        expect(visible.count).to eq(1)
      end

      it 'excludes outside projects' do
        expect(visible).not_to include(bar_project)
      end

      it 'includes own projects' do
        expect(visible).to include(foo_project)
      end
    end

    context 'as an HQ employee' do
      let(:visible) { Project.visible(hq_employee) }

      it 'has the proper count' do
        expect(visible.count).to eq(2)
      end

      it 'includes all projects' do
        expect(visible).to include(foo_project)
        expect(visible).to include(bar_project)
      end
    end
  end

end