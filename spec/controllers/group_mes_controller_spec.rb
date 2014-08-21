require 'rails_helper'

RSpec.describe GroupMesController, :type => :controller do

  describe "GET 'auth'" do
    it "returns http success" do
      get 'auth'
      expect(response).to be_success
    end
  end

  describe "GET 'called_back'" do
    it "returns http success" do
      get 'called_back'
      expect(response).to be_success
    end
  end

end
