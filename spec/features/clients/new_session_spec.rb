require 'rails_helper'

describe 'client representative login functionality' do
  let!(:client_representative) { create :client_representative }

  before do
    visit new_session_client_representatives_path
    fill_in 'Email address', with: 'foo@barson.com'
    fill_in 'Password', with: 'foobar'
    click_on 'Log in'
  end

  it 'logs in a user' do
    expect(page).to have_content('Successfully logged in.')
  end

  it 'changes the session client_representative_id' do
    expect(page.get_rack_session_key('client_representative_id')).to eq(client_representative.id)
  end

end