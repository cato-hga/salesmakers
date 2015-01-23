require 'rails_helper'

describe RootRedirectsController do

  describe 'GET incoming_redirect' do

    let(:employee) { create :person, department: department }
    before(:each) do
      get :incoming_redirect
    end
    it 'returns a success status' do
      expect(response).to be_success
    end

    it 'routes employees based upon their department'
  end
end