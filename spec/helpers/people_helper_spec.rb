require 'rails_helper'

describe PeopleHelper do
  let(:area) { create :area }

  it 'does not display subarea content for areas without children' do
    areas = area.subtree.arrange
    areas_markup = helper.people_nested_areas(areas)
    expect(areas_markup).not_to have_selector('ul')
  end

  it 'displays subarea content for areas with children' do
    create :area, name: 'Foo', parent_id: area.id
    areas = area.subtree.arrange
    areas_markup = helper.people_nested_areas(areas)
    expect(areas_markup).to have_selector('ul')
  end
end