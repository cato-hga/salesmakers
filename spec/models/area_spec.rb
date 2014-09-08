require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe Area, :type => :model do

  it { should ensure_length_of(:name).is_at_least(3) }
  it { should validate_presence_of(:area_type) }

  it { should belong_to(:area_type) }
  it { should belong_to(:project) }
  it { should have_many(:person_areas) }
  it { should have_many(:people).through(:person_areas) }
  it { should have_one(:wall) } #TODO: test for as: :wallable here?

  #TODO: Test for Ancestry This link looks good: http://stackoverflow.com/questions/20557022/factories-with-ancestry-for-testing

  #TODO: Test :visible scope

  #TODO: Below test doesn't seem to work. Null value in column 'wallable_id" "
  # describe 'create_wall' do
  #   it 'should create wall after saving' do
  #     area = Area.new
  #     area.wall.should_receive(:create)
  #     area.send(:create_wall)
  #   end
  # end

end
