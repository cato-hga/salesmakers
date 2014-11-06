require 'rails_helper'

describe PeopleHelper do
  it 'does not display subarea content for areas without children' do
    Area.destroy_all
    area = create :area
    areas = area.subtree.arrange
    areas_markup = helper.people_nested_areas(areas)
    expect(areas_markup).not_to have_selector('ul')
  end

  it 'displays subarea content for areas with children' do
    areas = Area.first.subtree.arrange
    areas_markup = helper.people_nested_areas(areas)
    puts areas_markup
    expect(areas_markup).to have_selector('ul')
  end
end