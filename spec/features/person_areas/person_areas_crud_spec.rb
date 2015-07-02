require 'rails_helper'

describe 'PersonArea CRUD actions' do
  let!(:it_tech) { create :it_tech_person, position: position }
  let(:position) {
    create :it_tech_position,
           permissions: [
               person_area_create_permission,
               person_area_update_permission,
               person_area_destroy_permission
           ]
  }
  let(:person_area_create_permission) { create :permission, key: 'person_area_create' }
  let(:person_area_update_permission) { create :permission, key: 'person_area_update' }
  let(:person_area_destroy_permission) { create :permission, key: 'person_area_destroy' }
  let(:person) { create :person }

  before do
    CASClient::Frameworks::Rails::Filter.fake(it_tech.email)
  end

  context 'for the index' do
    let(:area) { create :area, name: 'The area for the person' }
    let!(:person_area) { create :person_area, person: person, area: area }

    before do
      visit person_path(person)
      click_on 'Edit Areas'
    end

    it 'shows the areas' do
      expect(page).to have_content area.name
    end
  end

  context 'for creation' do
    let!(:area) { create :area }

    before do
      visit person_person_areas_path(person)
      click_on 'new_action_button'
      find('input[value="' + area.id.to_s + '"]').set(true)
    end

    subject { click_on 'Save' }

    it 'creates the PersonArea' do
      expect {
        subject
      }.to change(PersonArea, :count).by(1)
    end

    it 'creates a LogEntry' do
      expect {
        subject
      }.to change(LogEntry, :count).by(1)
    end
  end

  context 'for editing' do
    let!(:person_area) { create :person_area, person: person, manages: true }

    before do
      visit person_person_areas_path(person)
      click_on person_area.area.name
      find('#person_area_manages').set(false)
    end

    subject { click_on 'Save' }

    it 'creates a LogEntry' do
      expect {
        subject
      }.to change(LogEntry, :count).by(1)
    end

    it 'changes the values of the attributes' do
      subject
      person_area.reload
      expect(person_area.manages?).to eq(false)
    end
  end

  context 'for destruction' do
    let!(:person_area) { create :person_area, person: person, manages: true }

    before do
      visit person_person_areas_path(person)
      click_on person_area.area.name
    end

    subject { click_on 'delete_action_button' }

    it 'creates a LogEntry' do
      expect {
        subject
      }.to change(LogEntry, :count).by(1)
    end

    it 'destroys the PersonArea' do
      expect {
        subject
      }.to change(PersonArea, :count).by(-1)
    end
  end
end
