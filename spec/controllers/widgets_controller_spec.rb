require 'rails_helper'

RSpec.describe WidgetsController, :type => :controller do

  describe "GET 'sales'" do
    it "returns http success" do
      get 'sales'
      expect(response).to be_success
    end
  end

  describe "GET 'hours'" do
    it "returns http success" do
      get 'hours'
      expect(response).to be_success
    end
  end

  describe "GET 'tickets'" do
    it "returns http success" do
      get 'tickets'
      expect(response).to be_success
    end
  end

  describe "GET 'social'" do
    it "returns http success" do
      get 'social'
      expect(response).to be_success
    end
  end

  describe "GET 'alerts'" do
    it "returns http success" do
      get 'alerts'
      expect(response).to be_success
    end
  end

  describe "GET 'image_gallery'" do
    it "returns http success" do
      get 'image_gallery'
      expect(response).to be_success
    end
  end

  describe "GET 'inventory'" do
    it "returns http success" do
      get 'inventory'
      expect(response).to be_success
    end
  end

  describe "GET 'staffing'" do
    it "returns http success" do
      get 'staffing'
      expect(response).to be_success
    end
  end

  describe "GET 'gaming'" do
    it "returns http success" do
      get 'gaming'
      expect(response).to be_success
    end
  end

  describe "GET 'commissions'" do
    it "returns http success" do
      get 'commissions'
      expect(response).to be_success
    end
  end

  describe "GET 'training'" do
    it "returns http success" do
      get 'training'
      expect(response).to be_success
    end
  end

  describe "GET 'gift_cards'" do
    it "returns http success" do
      get 'gift_cards'
      expect(response).to be_success
    end
  end

end
