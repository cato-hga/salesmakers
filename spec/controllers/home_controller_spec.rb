# require 'rails_helper'
#
# describe HomeController do
#   let!(:person) { create :it_tech_person }
#   before(:each) do
#     CASClient::Frameworks::Rails::Filter.fake("ittech@salesmakersinc.com")
#   end
#
#   describe 'GET index' do
#     it 'returns a success status' do
#       get :index
#       expect(response).to be_success
#       expect(response).to render_template(:index)
#     end
#   end
#
# end