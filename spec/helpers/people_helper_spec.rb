require 'rails_helper'

describe PeopleHelper do
  let(:area) { create :area }

  it 'displays subarea content for areas with children' do
    create :area, name: 'Foo', parent_id: area.id
    areas = area.subtree.arrange
    areas_markup = helper.people_nested_areas(areas)
    expect(areas_markup).to have_selector('ul')
  end
end
