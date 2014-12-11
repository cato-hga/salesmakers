require 'rails_helper'

describe 'Device States CRUD' do

  describe 'GET index' do
    let!(:state) { create :device_state }
    before(:each) do
      visit device_states_path
    end
    it 'should show a list of device states' do
      expect(page).to have_content(state.name)
    end
    it 'should have a button to add a new state' do
      expect(page).to have_link('New')
    end
    it 'should have a button to edit states' do
      expect(page).to have_link('Edit State')
    end
  end

  describe 'GET new' do

  end
end