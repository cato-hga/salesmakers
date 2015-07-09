require 'rails_helper'

describe 'Syncing a GroupMe account' do

  let!(:person) { create :person }
  before do
    CASClient::Frameworks::Rails::Filter.fake(person.email)
    visit auth_page_group_mes_path
  end
  it 'is available from /groupme/sync' do
    expect(page).to have_content 'Log in with GroupMe'
  end
end