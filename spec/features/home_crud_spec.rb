require 'rails_helper'

describe 'Home CRUD actions' do

  describe 'on the index page' do
    let!(:person) { create :it_tech_person }

    before(:each) do
      CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
      visit home_index_path
    end

    it 'should have the correct page heading' do
      expect(page).to have_selector('h1', text: 'Home')
    end

    it 'should have the restart tour button' do
      expect(page).to have_selector('a', text: 'Restart Tour')
    end

    it 'should show the share box' do
      within(:css, 'div.widgets') do
        expect(page).to have_css('div.share_form')
      end
    end
  end

end
