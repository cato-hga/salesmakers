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

end