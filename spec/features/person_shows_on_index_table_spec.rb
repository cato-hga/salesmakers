require 'rails_helper'

feature 'Person shows on index table' do
  scenario 'When a person is present they show on the table' do
    FactoryGirl.create :smiles

    visit people_path

    expect(page).to have_content 'smiles@retaildoneright.com'
  end
end


