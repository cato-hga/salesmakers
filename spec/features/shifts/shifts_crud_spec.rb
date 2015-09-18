require 'rails_helper'

describe 'shifts CRUD actions' do
  let!(:shift) { create :shift, location: location }
  let(:location) { create :location }
  let!(:location_area) { create :location_area, location: location, area: person_area.area }
  let(:person) { shift.person }
  let!(:person_area) { create :person_area, person: person }

  context 'as a rep' do
    before do
      CASClient::Frameworks::Rails::Filter.fake(person.email)
      visit shifts_path
    end

    it 'has the proper title' do
      expect(page).to have_selector 'h1', text: "Shifts"
    end

    it 'has the shift date' do
      expect(page).to have_selector 'td', text: shift.date.strftime('%m/%d/%Y')
    end

    it 'has the rep name' do
      expect(page).to have_selector 'td a', text: NameCase(person.display_name)
    end

    it 'shows the project' do
      expect(page).to have_selector 'td', text: person_area.area.project.name
    end

    it 'shows the area' do
      expect(page).to have_selector 'td a', text: location_area.area.name
    end

    it 'should have the shift location' do
      expect(page).to have_selector 'td a', text: shift.location.name
    end

    it 'has the shift hours' do
      expect(page).to have_selector 'td', text: shift.hours.round(2).to_s
    end

    it 'has an indicator that the shift is not a training shift nor a meeting shift' do
      expect(page).not_to have_selector 'td i[class="fi-check"]'
    end
  end
end