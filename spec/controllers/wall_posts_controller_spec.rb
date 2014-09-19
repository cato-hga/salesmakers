require 'rails_helper'

RSpec.describe WallPostsController, :type => :controller do

  describe "GET 'promote'" do
    it "returns http success" do
      get 'promote'
      expect(response).to be_success
    end
  end

  describe "GET 'destroy'" do
    it "returns http success" do
      get 'destroy'
      expect(response).to be_success
    end
  end

end
