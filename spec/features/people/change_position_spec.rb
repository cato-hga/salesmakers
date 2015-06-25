require 'rails_helper'

describe 'updating positions for people' do
  let!(:it_tech) { create :it_tech_person, position: position }
  let(:position) {
    create :it_tech_position,
           permissions: [
               person_update_position_permission
           ]
  }
  let(:person_update_position_permission) { create :permission, key: 'person_update_position' }
  let(:department) { create :department }
  let!(:position_to_set) { create :position, name: 'Best Position Ever' }
  let!(:old_position) { create :position, name: 'Worst Position Ever' }
  let!(:person) { create :person, position: old_position }

  before do
    CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
    visit person_path(person)
    click_on 'Edit Position'
    select position_to_set.name, from: 'position'
    click_on 'Save'
  end

  it "should change the person's position" do
    person.reload
    expect(person.position).to eq(position_to_set)
  end

  it "should create a log entry" do
    expect(LogEntry.count).to eq(1)
  end
end