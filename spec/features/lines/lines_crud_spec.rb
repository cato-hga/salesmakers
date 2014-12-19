require 'rails_helper'

describe 'Lines CRUD actions' do

  describe 'GET index' do
    it 'contains a link to lines#new' do
      visit lines_path
      expect(page).to have_link('New')
    end
  end
end