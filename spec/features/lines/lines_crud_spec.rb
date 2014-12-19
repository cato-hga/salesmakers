require 'rails_helper'

describe 'Lines CRUD actions' do

  describe 'GET index' do
    before {
      visit lines_path
    }

    it 'contains a link to lines#new' do
      expect(page).to have_link('New')
    end

    it 'contains a link to lines#line_swap' do
      expect(page).to have_link('Swap Lines')
    end
  end
end
