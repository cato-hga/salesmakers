# == Schema Information
#
# Table name: client_areas
#
#  id                  :integer          not null, primary key
#  name                :string           not null
#  client_area_type_id :integer          not null
#  ancestry            :string
#  created_at          :datetime
#  updated_at          :datetime
#  project_id          :integer          not null
#

require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe ClientArea, :type => :model do

  it { should ensure_length_of(:name).is_at_least(3) }
  it { should validate_presence_of(:client_area_type) }

  it { should belong_to(:client_area_type) }
  it { should belong_to(:project) }
  #it { should have_many(:person_client_areas) }
  #it { should have_many(:people).through(:person_client_areas) }

  it ' project_roots scope should return project_roots' do
    proj = Project.first
    expect(ClientArea.project_roots(proj)).not_to be_nil
  end

  # describe 'locations' do
  #   let(:client_area_one) { create :client_area }
  #   let(:client_area_two) { create :client_area, name: 'Area Two' }
  #   let(:location_one) { create :location }
  #   let(:location_two) { create :location }
  #   let!(:location_client_area_one) {
  #     create :location_client_area,
  #            location: location_one,
  #            client_area: client_area_one
  #   }
  #   let!(:location_client_area_two) {
  #     create :location_client_area,
  #            location: location_two,
  #            client_area: client_area_two
  #   }
  #
  #   before do
  #     client_area_two.update parent: client_area_one
  #   end
  #
  #   it 'returns only the locations in the client_area with #locations' do
  #     expect(client_area_one.locations.count).to eq(1)
  #   end
  #
  #   it 'returns all locations in the tree for #all_locations' do
  #     expect(client_area_one.all_locations.count).to eq(2)
  #   end
  # end
end
