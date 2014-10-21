require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Area, :type => :model do

  it { should ensure_length_of(:name).is_at_least(3) }
  it { should validate_presence_of(:area_type) }

  it { should belong_to(:area_type) }
  it { should belong_to(:project) }
  it { should have_many(:person_areas) }
  it { should have_many(:people).through(:person_areas) }
  it { should have_one(:wall) }

  it 'should all areas a person is a member of' do
  end

  it 'should return project_roots' do
    proj = Project.first
    expect(Area.roots.where(project: proj).order(:name)).not_to be_nil
  end
end
