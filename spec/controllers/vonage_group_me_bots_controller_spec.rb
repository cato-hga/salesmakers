require 'rails_helper'

describe VonageGroupMeBotsController do

  describe 'POST message' do
    before do
      post :message, '{ "text" : "!atl", "name" : "lah", "system" : "false", "user_id" : 12345, "attachments": [] }'
    end

    it 'returns a success status' do
      expect(response).to be_success
    end
  end

end