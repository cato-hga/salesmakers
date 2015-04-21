require 'rails_helper'

describe 'changelog entry display' do
  let!(:person) {
    create :it_tech_person
  }
  let!(:feature_one) {
    create :changelog_entry,
           heading: 'Feature One',
           released: Time.now - 8.days
  }
  let!(:feature_two) {
    create :changelog_entry,
           heading: 'Feature Two',
           released: Time.now - 6.days
  }
  let!(:feature_three) {
    create :changelog_entry,
           heading: 'Feature Three',
           released: Time.now - 23.hours
  }
  let!(:feature_four) {
    create :changelog_entry,
           heading: 'Feature Four',
           released: Time.now - 3.hours
  }
  let!(:permission) { create :permission, key: 'device_index' }

  before do
    person.position.permissions << permission
    CASClient::Frameworks::Rails::Filter.fake(person.email)
  end

  context 'no changelog_entry_id' do
    before do
      visit root_path
    end

    it 'shows features within one week' do
      expect(page).to have_content(feature_four.heading)
      expect(page).to have_content(feature_three.heading)
      expect(page).to have_content(feature_two.heading)
    end

    it 'does not show features past one week' do
      expect(page).not_to have_content(feature_one.heading)
    end
  end

  context 'last dismissed all but one feature' do
    before do
      person.update changelog_entry_id: feature_three.id
      visit root_path
    end

    it 'shows the feature after last dismissed' do
      expect(page).to have_content(feature_four.heading)
    end

    it 'does not show features before last dismissed' do
      expect(page).not_to have_content(feature_one.heading)
      expect(page).not_to have_content(feature_two.heading)
      expect(page).not_to have_content(feature_three.heading)
    end
  end

  context 'last dismissed all features' do
    before do
      person.update changelog_entry_id: feature_four.id
      visit root_path
    end

    it 'shows no features' do
      expect(page).not_to have_content(feature_one.heading)
      expect(page).not_to have_content(feature_two.heading)
      expect(page).not_to have_content(feature_three.heading)
      expect(page).not_to have_content(feature_four.heading)
    end
  end

  context 'dismissal' do
    before do
      visit root_path
    end

    it 'dismisses the changelog entry with the dismiss link', js: true do
      within '#changelog' do
        find('a', text: 'Dismiss').click
      end
      sleep 2
      visit root_path
      expect(page).not_to have_content(feature_four.heading)
    end
  end

end